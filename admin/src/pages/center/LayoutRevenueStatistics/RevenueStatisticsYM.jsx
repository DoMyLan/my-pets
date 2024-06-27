import React from 'react';
import { Paper, Typography, Dialog, Grid, CircularProgress, Select, MenuItem, DialogTitle, DialogContent, Button, Avatar } from '@material-ui/core';
import { BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip, Legend } from 'recharts';
import revenueAPI from '~/services/apis/managerCenter/revenue';
import { useEffect, useState } from 'react';
import orderAPI from '~/services/apis/managerCenter/orderAPI';
import { enqueueSnackbar } from 'notistack';
import Table1 from "~/components/Table/Table";
import cod from '~/assets/img/cash-on-delivery.png';
import vnpay from '~/assets/img/vnpay.png';


const RevenueStatisticsPageYM = () => {
    const [data, setData] = useState([]);
    const [isLoading, setIsLoading] = useState(false);
    const [totalRevenue, setTotalRevenue] = useState(0);
    const [selectedYear, setSelectedYear] = useState(new Date().getFullYear()); // State for selected year
    const [selectedMonth, setSelectedMonth] = useState(new Date().getMonth() + 1); // JavaScript months are 0-indexed
    const [paidRevenue, setPaidRevenue] = useState(0);
    const [pendingRevenue, setPendingRevenue] = useState(0);
    const years = Array.from(new Array(new Date().getFullYear() - 2019), (val, index) => 2020 + index);
    const [order, setOrder] = useState([]);
    const [openDetail, setOpenDetail] = useState(false);
    const [loading, setLoading] = useState(false);

    const customerTableHead = [
        "STT",
        "Mã đơn hàng",
        "Người mua",
        "Thú cưng",
        "Địa chỉ giao hàng",
        "Giá (VND)",
        "Phí vận chuyển (VND)",
        "Tổng đơn hàng (VND)",
        "Tổng thanh toán (VND)",
        "Tổng giảm giá (VND)",
        "Hình thức thanh toán",
        "Trạng thái thanh toán",
        "Ngày đặt hàng",
        "Ngày hoàn thành",
        "Ngày thanh toán",
    ];

    const ImageSlideshow = ({ images }) => {
        const [currentImageIndex, setCurrentImageIndex] = useState(0);

        useEffect(() => {
            const timer = setInterval(() => {
                setCurrentImageIndex((prevIndex) => (prevIndex + 1) % images.length);
            }, 3000); // Change image every 3 seconds

            return () => clearInterval(timer);
        }, [images.length]);

        return (
            <Avatar
                alt="Slideshow"
                src={images[currentImageIndex]}
                style={{ borderRadius: "0", width: "60px", height: "40px" }}
            />
        );
    };

    const renderHead = (item, index) => <th key={index}>{item}</th>;

    useEffect(() => {
        setIsLoading(true);
        revenueAPI.getRevenueYearMonth(selectedYear, selectedMonth).then((dataRes) => {
            setData(dataRes.data);
            //tính tổng doanh thu
            let total = 0;
            let paid = 0;
            let pending = 0;
            dataRes.data.forEach((item) => {
                total += item.total;
                paid += item.paid;
                pending += item.pending;
            });
            setTotalRevenue(total);
            setPaidRevenue(paid);
            setPendingRevenue(pending);

        }).catch((error) => { });
        setIsLoading(false);
    }, [selectedYear, selectedMonth]);

    const handleMonthChange = (event) => {
        setSelectedMonth(event.target.value);
    };


    const handleGetOrder = (statusPayment) => {
        setLoading(true);
        setOrder([]);
        orderAPI.getOrderStatusPaymentYM(statusPayment, selectedYear, selectedMonth)
            .then((dataRes) => {
                setOrder(dataRes.data);
            }).catch((error) => {
                enqueueSnackbar("Lấy danh sách đơn hàng thất bại", { variant: "error" });
            });
        setLoading(false);
        setOpenDetail(true);

    }

    const handleYearChange = (event) => {
        setSelectedYear(event.target.value);
        // You might want to fetch new data based on the selected year here
    };

    const renderBody = (item, index) => (
        <tr key={index}>
            <td>{index + 1}</td>
            <td>
                {item._id}{" "}
            </td>
            <td style={{ minWidth: "180px" }}>
                <div className="action" style={{ display: "flex", alignItems: "center" }}>
                    <Avatar className="avatar" alt="Cindy Baker" src={item.buyer.avatar} />
                    <div className="name" style={{ marginLeft: "10px" }}>
                        {item.buyer.firstName} {item.buyer.lastName}
                    </div>
                </div>
            </td>
            <td style={{ minWidth: "150px" }}>
                <div className="action" style={{ display: "flex", alignItems: "center", justifyContent: "space-between" }}>
                    <div style={{ marginLeft: "2px", justifyContent: "flex-start" }}>
                        <ImageSlideshow images={item.petId.images} />
                        <div className="name" >
                            {item.petId.namePet}
                        </div>
                    </div>
                    <button className="btn btn--view-report" style={{ marginLeft: "10px", width: "90px", background: "grey", color: "white" }}
                        onClick={() => { handleViewDetailPet(item.petId._id) }}>Chi tiết</button>
                </div>
            </td>
            <td style={{ minWidth: "200px" }}>{item.address}</td>
            <td style={{ textAlign: "end" }}>{parseInt(item.price).toLocaleString()}</td>
            <td style={{ textAlign: "end" }}>{parseInt(item.transportFee).toLocaleString()}</td>
            <td style={{ textAlign: "end" }}>{parseInt(item.totalFee).toLocaleString()}</td>
            <td style={{ textAlign: "end" }}>{item.totalPayment.toLocaleString()}</td>
            <td style={{ textAlign: "end" }}>{(item.voucherProduct + item.voucherShipping + item.voucherTotal).toLocaleString()}</td>
            <td>
                {item.paymentMethods === 'COD' ? (
                    <img src={cod} alt="COD" style={{ width: '24px', height: '24px' }} />
                ) : (
                    <img src={vnpay} alt="VNPAY" style={{ width: '24px', height: '24px' }} />
                )}
            </td>
            <td style={{ color: item.statusPayment === "PENDING" ? "orange" : "green", fontWeight: "bold", minWidth: "120px" }}>
                {item.statusPayment === "PENDING" ? "Chờ thanh toán" : "Đã thanh toán"}
            </td>
            <td>{new Date(item.createdAt).toLocaleDateString('vi-VN', {
                  day: '2-digit',
                  month: '2-digit',
                  year: 'numeric',
                })}</td>
            <td>{new Date(item.dateCompleted).toLocaleDateString('vi-VN', {
                  day: '2-digit',
                  month: '2-digit',
                  year: 'numeric',
                })}</td>
            <td>{new Date(item.datePaid).toLocaleDateString('vi-VN', {
                  day: '2-digit',
                  month: '2-digit',
                  year: 'numeric',
                })}</td>
        </tr>
    );


    return (
        <div style={{ padding: 5 }}>
            <Typography variant="h4" gutterBottom>Thống Kê Doanh Thu</Typography>
            <Grid container spacing={3}>
                <Grid item xs={12} sm={6}>
                    <Paper style={{ padding: 20 }}>
                        <Typography variant="h6">Tổng doanh thu tháng {selectedMonth} năm {selectedYear} </Typography>
                        {isLoading ? <CircularProgress /> : <Typography variant="body1">{totalRevenue.toLocaleString()} VND</Typography>}
                    </Paper>
                </Grid>
                <Grid item xs={12} sm={6}>
                    <Paper style={{ padding: 20 }}>
                        <Typography variant="h6">Đơn Hàng</Typography>
                        <Grid container spacing={2} alignItems="center" justify="space-around" style={{ margin: '20px 0' }}>


                            <Button variant="contained" onClick={() => { handleGetOrder("PAID") }}>
                                <div style={{ display: 'flow', justifyContent: 'space-between' }}>
                                    <Typography variant="h6" gutterBottom>Đã Thanh Toán</Typography>
                                    <Typography variant="body1">{paidRevenue.toLocaleString()} VND</Typography></div>
                            </Button>
                            <Button variant="contained" onClick={() => { handleGetOrder("PENDING") }}>
                                <div style={{ display: 'flow', justifyContent: 'space-between' }}>
                                    <Typography variant="h6" gutterBottom>Chưa thanh toán</Typography>
                                    <Typography variant="body1">{pendingRevenue.toLocaleString()} VND</Typography></div>
                            </Button>
                        </Grid>
                    </Paper>
                </Grid>
                <Grid item xs={12}>{isLoading ? <CircularProgress /> :
                    <>
                        <Paper style={{ padding: 20 }}>
                            <div style={{ display: 'flex', justifyContent: 'center' }}>
                                <Typography variant="h6">Biểu Đồ Doanh Thu</Typography>
                                <Select style={{ width: 100, marginLeft: 100 }}
                                    value={selectedYear}
                                    onChange={handleYearChange}
                                    displayEmpty
                                    fullWidth

                                >
                                    {years.map((year) => (
                                        <MenuItem key={year} value={year} style={{ background: 'white' }}>{`Năm ${year}`}</MenuItem>
                                    ))}
                                </Select>
                                <Select style={{ marginLeft: 30 }} value={selectedMonth} onChange={handleMonthChange}>
                                    {Array.from({ length: 12 }, (_, i) => (
                                        <option style={{ background: "white", cursor: "pointer" }} key={i} value={i + 1}>
                                            {`Tháng ${i + 1}`}
                                        </option>
                                    ))}
                                </Select></div>

                            <BarChart width={800} height={400} data={data} margin={{
                                top: 50,
                                right: 30,
                                left: 50, // Increase left margin to give more space for Y-axis labels
                                bottom: 5,
                            }}>
                                <CartesianGrid strokeDasharray="1 1" />
                                <XAxis dataKey="day" label={{ value: '(Ngày)', position: 'insideBottomRight', offset: -15, dx: -10 }} />
                                <YAxis label={{ value: 'VND', angle: -90, position: 'insideTopLeft', dy: -15, dx: 25 }} />
                                <Tooltip />
                                <Legend />
                                <Bar name="Đã thanh toán" dataKey="paid" fill="green" />
                                <Bar name="Chưa thanh toán" dataKey="pending" fill="orange" />
                                <Bar name="Tổng" dataKey="total" fill="blue" />
                            </BarChart>
                        </Paper></>}
                </Grid>
            </Grid>
            <Dialog open={openDetail} onClose={() => { setOpenDetail(false) }} fullWidth maxWidth="lg">
                <DialogTitle>
                    Thông tin đơn hàng
                </DialogTitle>
                <DialogContent>
                    {loading ? (
                        <CircularProgress />
                    ) : (
                        <div>
                            <div className="row">
                                <div className="col l-12">
                                    <div className="card-admin">
                                        <div className="card__body">
                                            <Table1
                                                limit="10"
                                                headData={customerTableHead}
                                                renderHead={(item, index) => renderHead(item, index)}
                                                bodyData={order}
                                                renderBody={(item, index) => renderBody(item, index)}
                                            />
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>)}
                </DialogContent>
            </Dialog>
        </div >
    );
};

export default RevenueStatisticsPageYM;