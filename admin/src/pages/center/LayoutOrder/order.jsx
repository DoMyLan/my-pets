import { useSnackbar } from "notistack";

import Table1 from "~/components/Table/Table";
import "./ManageOrder.scss";
import { Avatar } from "@mui/material";
import React, { useState, useEffect } from "react";
import cod from '~/assets/img/cash-on-delivery.png';
import vnpay from '~/assets/img/vnpay.png';

import { CircularProgress, Dialog, DialogContent, DialogTitle, IconButton, Chip } from "@mui/material";
import petAPI from "~/services/apis/petAPI/petAPI";
import orderAPI from "~/services/apis/managerCenter/orderAPI";

const Order = (props) => {
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
    "Hành động",
  ];

  const renderHead = (item, index) => <th key={index}>{item}</th>;

  const { enqueueSnackbar } = useSnackbar();
  const [loading, setLoading] = useState(false);
  const [petDetail, setPetDetail] = useState(null);
  const [openDetail, setOpenDetail] = useState(false);
  const [anchorEl, setAnchorEl] = useState(null);
  const [showConfirmDialog, setShowConfirmDialog] = useState(false);
  const [currentAction, setCurrentAction] = useState('');
  const [currentOrderId, setCurrentOrderId] = useState(null);

  const handleConfirm = () => {
    handleOrder(currentOrderId, currentAction);
    setShowConfirmDialog(false);
  };

  const handleCancel = () => {
    setShowConfirmDialog(false);
  };

  const handleClose = () => {
    setAnchorEl(null);
    setOpenDetail(false);
  };

  const handleOrder = (id, statusOrder) => {
    setLoading(true);
    orderAPI.updateOrder(id, { statusOrder: statusOrder }).then((dataRes) => {
      const updatedOrderList = props.data.filter(
        (order) => order._id !== id
      );
      if (statusOrder === "CONFIRMED") {
        var newListOrderCF;
        props.data.map((order) => {
          if (order._id === id) {
            newListOrderCF = [
              ...props.listOrderCF,
              { ...order, statusOrder: "CONFIRMED" },
            ];
          }
        });
        props.setListOrderCF(newListOrderCF);
        props.setListOrderPD(updatedOrderList);
      } else if (statusOrder === "DELIVERING") {
        var newListOrderDLING;
        props.data.map((order) => {
          if (order._id === id) {
            newListOrderDLING = [
              ...props.listOrderDLING,
              { ...order, statusOrder: "DELIVERING" },
            ];
          }
        });
        props.setListOrderDLING(newListOrderDLING);
        props.setListOrderCF(updatedOrderList);
      } else if (statusOrder === "DELIVERED") {
        var newListOrderDLED;
        props.data.map((order) => {
          if (order._id === id) {
            newListOrderDLED = [
              ...props.listOrderDLED,
              { ...order, statusOrder: "DELIVERED" },
            ];
          }
        });
        props.setListOrderDLED(newListOrderDLED);
        props.setListOrderDLING(updatedOrderList);
      }
      else if (statusOrder === "CANCEL") {
        var newListOrderCC;
        props.data.map((order) => {
          if (order._id === id) {
            newListOrderCC = [
              ...props.listOrderCC,
              { ...order, statusOrder: "CANCEL" },
            ];
          }
        });
        props.setListOrderCC(newListOrderCC);
        props.setListOrderPD(updatedOrderList);
      }

      enqueueSnackbar("Cập nhật đơn hàng thành công", { variant: "success" });
      setLoading(false);
    }).catch((error) => {
      enqueueSnackbar("Lỗi không thể cập nhật đơn hàng", { variant: "error" });
      setLoading(false);
    });
  }

  const handleViewDetailPet = (id) => {
    setLoading(true);
    petAPI.getPetById(id).then((dataRes) => {
      setPetDetail(dataRes.data);
      setAnchorEl(null);
      setLoading(false);
      setOpenDetail(true);
    }).catch((error) => { });

  }


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
      <td>
        {item.statusOrder === "PENDING" ? (
          <>
            <button anchorEl={anchorEl} className="btn btn--view-report" style={{ background: "grey", color: "white" }}
              onClick={() => { setCurrentAction("CONFIRMED"); setCurrentOrderId(item._id); setShowConfirmDialog(true); }}>Xác nhận</button>
            <button className="btn btn--view-report" style={{ background: "orange", color: "white" }}
              onClick={() => { setCurrentAction("CANCEL"); setCurrentOrderId(item._id); setShowConfirmDialog(true); }}>Hủy</button>
          </>
        ) : (
          item.statusOrder === "CONFIRMED" ? (
            <button className="btn btn--view-report" style={{ background: "grey", color: "white" }}
              onClick={() => { setCurrentAction("DELIVERING"); setCurrentOrderId(item._id); setShowConfirmDialog(true); }}>Vận chuyển</button>
          ) : (
            item.statusOrder === "DELIVERING" ? (
              <button className="btn btn--view-report" style={{ background: "grey", color: "white" }}
                onClick={() => { setCurrentAction("DELIVERED"); setCurrentOrderId(item._id); setShowConfirmDialog(true); }}>Đã vận chuyển</button>
            ) : (
              <div></div>
            )
          )
        )}
      </td>
    </tr>
  );

  return (
    <div>
      <div className="row">
        <div className="col l-12">
          <div className="card-admin">
            <div className="card__body">
              <Table1
                limit="10"
                headData={customerTableHead}
                renderHead={(item, index) => renderHead(item, index)}
                bodyData={props?.data}
                renderBody={(item, index) => renderBody(item, index)}
              />
            </div>
          </div>
        </div>
      </div>
      <Dialog open={openDetail} onClose={handleClose}>
        <DialogTitle>
          <div style={{ display: "flex" }}>
            <h2 style={{ fontSize: 18, textAlign: "center" }}>
              Thông tin thú cưng
            </h2>
            <IconButton aria-label="close" onClick={handleClose} style={{ marginLeft: "150px" }}>
              X
            </IconButton>
          </div>
        </DialogTitle>
        <DialogContent>
          {loading ? (
            <CircularProgress />
          ) : petDetail ? (
            <><div style={{ maxWidth: "1000px", margin: "0 auto", padding: "20px", boxShadow: "0 2px 4px rgba(0,0,0,0.3)" }}>
              <div style={{ display: 'flex', alignItems: "center", marginBottom: "20px" }}>
                <Avatar
                  src={petDetail.centerId.avatar}
                  style={{ marginRight: "20px", width: "60px", height: "60px" }}
                />
                <h3 style={{ margin: 0 }}>{petDetail.centerId.name}</h3>
              </div>

              <p style={{ margin: "10px 0" }}>Tên thú cưng: {petDetail?.namePet}</p>
              <p style={{ margin: "10px 0" }}>Loại: {petDetail.petType}</p>
              <p style={{ margin: "10px 0" }}>Giống: {petDetail.breed}</p>
              <p style={{ margin: "10px 0" }}>Giá: {petDetail.price + " VND"}</p>
              <p style={{ margin: "10px 0" }}>Giảm giá: {petDetail.reducePrice}</p>
              <p style={{ margin: "10px 0" }}>
                Ngày sinh: {new Date(petDetail.birthday).toLocaleDateString('vi-VN', {
                  day: '2-digit',
                  month: '2-digit',
                  year: 'numeric',
                })}
              </p>
              <p style={{ margin: "10px 0" }}>Giới tính: {petDetail.gender === "MALE" ? "Giống đực" : "Giống cái"}</p>
              <p style={{ margin: "10px 0" }}>Cân nặng: {petDetail.weight} Kg</p>
              <p style={{ margin: "10px 0" }}>Nguồn gốc: {petDetail.original}</p>
              <p style={{ margin: "10px 0" }}>Hướng dẫn chăm sóc: {petDetail.instruction}</p>
              <p style={{ margin: "10px 0" }}>Chú ý: {petDetail.attention}</p>
              <p style={{ margin: "10px 0" }}>Sở thích: {petDetail.hobbies}</p>
              <p style={{ margin: "10px 0" }}>Tình trạng tiêm chủng: {petDetail.inoculation}</p>
              <p style={{ margin: "10px 0" }}>Tình trạng: {petDetail.statusPaid === "NOTHING" ? "Chưa bán" : petDetail.statusPaid === "PENDING" ? "Đang xử lý" : "Đã bán"}</p>
              <p style={{ margin: "10px 0" }}>Màu sắc: {petDetail.color.map((color) => (
                <Chip key={color} label={color} style={{ marginRight: "5px" }} />
              ))}</p>

              <div style={{ display: "grid", gridTemplateColumns: "repeat(auto-fit, minmax(200px, 1fr))", gap: "10px", marginTop: "20px" }}>
                {petDetail?.images.map((image, index) => (
                  <img
                    key={index}
                    src={image}
                    alt="Pet"
                    style={{ width: "100%", height: "200px", objectFit: "cover" }}
                  />
                ))}
              </div>
            </div>
            </>
          ) : (
            <p>Post not found or deleted!</p>
          )}
        </DialogContent>
      </Dialog>
      <Dialog open={showConfirmDialog} onClose={handleCancel}>
        <DialogContent>
          <p>Bạn có chắc chắn {currentAction === "CONFIRMED" ? " xác nhận" : currentAction === "CANCEL" ? " hủy" : currentAction === "DELIVERING" ? " vận chuyển" : "hoàn thành"} đơn hàng?</p>
          <button onClick={handleConfirm}>{currentAction === "CONFIRMED" ? "Xác nhận" : currentAction === "CANCEL" ? "Hủy" : currentAction === "DELIVERING" ? "Vận chuyển" : "Hoàn thành"} đơn hàng</button>
          <button onClick={handleCancel} style={{ marginLeft: "30px" }}>Hủy</button>
        </DialogContent>
      </Dialog>
      <Dialog open={loading}>
        <DialogContent >
          {loading && <CircularProgress />}
        </DialogContent>
      </Dialog>
    </div>
  );
};

export default Order;
