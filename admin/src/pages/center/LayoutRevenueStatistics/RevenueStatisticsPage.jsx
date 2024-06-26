import React from 'react';
import { Paper, Typography, Button, Grid } from '@material-ui/core';
import { BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip, Legend } from 'recharts';

const data = [
    { name: 'Tháng 1', DoanhThu: 4000, DonHang: 2400 },
    { name: 'Tháng 2', DoanhThu: 3000, DonHang: 1398 },
    { name: 'Tháng 3', DoanhThu: 2000, DonHang: 9800 },
    { name: 'Tháng 4', DoanhThu: 2780, DonHang: 3908 },
    { name: 'Tháng 5', DoanhThu: 1890, DonHang: 4800 },
    { name: 'Tháng 6', DoanhThu: 2390, DonHang: 3800 },
];

const RevenueStatisticsPage = () => {
    return (
        <div style={{ padding: 20 }}>
            <Typography variant="h4" gutterBottom>Thống Kê Doanh Thu</Typography>
            <Grid container spacing={3}>
                <Grid item xs={12} sm={6}>
                    <Paper style={{ padding: 20 }}>
                        <Typography variant="h6">Tổng Doanh Thu</Typography>
                        {/* Thay thế giá trị bằng dữ liệu thực từ API */}
                        <Typography variant="body1">100,000,000 VND</Typography>
                    </Paper>
                </Grid>
                <Grid item xs={12} sm={6}>
                    <Paper style={{ padding: 20 }}>
                        <Typography variant="h6">Đơn Hàng</Typography>
                        <Button variant="contained" color="primary" style={{ marginRight: 10 }}>Đã Thanh Toán</Button>
                        <Button variant="contained" color="secondary">Chưa Thanh Toán</Button>
                    </Paper>
                </Grid>
                <Grid item xs={12}>
                    <Paper style={{ padding: 20 }}>
                        <Typography variant="h6">Biểu Đồ Doanh Thu</Typography>
                        <BarChart width={600} height={300} data={data}>
                            <CartesianGrid strokeDasharray="3 3" />
                            <XAxis dataKey="name" />
                            <YAxis />
                            <Tooltip />
                            <Legend />
                            <Bar dataKey="DoanhThu" fill="#8884d8" />
                            <Bar dataKey="DonHang" fill="#82ca9d" />
                        </BarChart>
                    </Paper>
                </Grid>
            </Grid>
        </div>
    );
};

export default RevenueStatisticsPage;