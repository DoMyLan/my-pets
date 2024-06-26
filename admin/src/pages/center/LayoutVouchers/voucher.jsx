import Table1 from "~/components/Table/Table";
import "./ManageVouchers";
import React, { useState, useEffect } from "react";
import { useSnackbar } from "notistack";
import MoreVertIcon from "@mui/icons-material/MoreVert";
import { CircularProgress, Dialog, DialogContent, DialogTitle, IconButton, Chip, Menu, MenuItem, TextField, FormControl, Select, Button } from "@mui/material";
import voucherAPI from "~/services/apis/managerCenter/voucherAPI";

const Voucher = (props) => {
  const customerTableHead = [
    "STT",
    "Mã",
    "Mã voucher",
    "Loại",
    "Khuyến mãi (%)",
    "Tối đa (VND)",
    "Ngày bắt đầu",
    "Ngày kết thúc",
    "Số lượng",
    "Đã sử dụng",
    "Trạng thái",
    "Hành động"
  ];

  const renderHead = (item, index) => <th key={index}>{item}</th>;

  const { enqueueSnackbar } = useSnackbar();
  const [loading, setLoading] = useState(false);
  const [loadingAdd, setLoadingAdd] = useState(false);
  const [openAddVoucher, setOpenAddVoucher] = useState(false);
  const [anchorId, setAnchorId] = useState(null);
  const [anchorEl, setAnchorEl] = useState(null);
  const [update, setUpdate] = useState(false);
  const [newVoucher, setNewVoucher] = useState({
    code: '',
    type: '',
    discount: '',
    maxDiscount: '',
    startDate: '',
    endDate: '',
    quantity: '',
    used: 0,
    status: '',
    createdBy: ''
  });

  const handleSave = (item) => {

    if (newVoucher.code === '' || newVoucher.type === '' || newVoucher.discount === '' || newVoucher.maxDiscount === '' || newVoucher.startDate === '' || newVoucher.endDate === '' || newVoucher.quantity === '' || newVoucher.status === '') {
      enqueueSnackbar("Vui lòng nhập đầy đủ thông tin", { variant: "error" });
      return;
    }
    if (!update) {

      setLoadingAdd(true);
      const user = JSON.parse(localStorage.getItem("user"));
      newVoucher.createdBy = user._id;

      voucherAPI.createVoucher(newVoucher).then((data) => {
        //giảm đi 7 giờ
        data.data.startDate = new Date(data.data.startDate).getTime() - 25200000;
        data.data.endDate = new Date(data.data.endDate).getTime() - 25200000;

        enqueueSnackbar("Thêm voucher thành công", { variant: "success" });
        props.setListVoucherAll([...props.listVoucherAll, data.data]);

        //kiểm tra voucher có hiệu lực hay không
        const start = new Date(data.data.startDate).getTime();
        const end = new Date(data.data.endDate).getTime();
        const now = new Date().getTime();
        if (now < start) {
          props.setListVoucherBefore([...props.listVoucherBefore, data.data]);
        } else if (now > start && now < end) {
          props.setListVoucherBetween([...props.listVoucherBetween, data.data]);
        }
        else {
          props.setListVoucherAfter([...props.listVoucherAfter, data.data]);
        }
      });
      setLoadingAdd(false);
      setOpenAddVoucher(false);
    } else {
      voucherAPI.update(newVoucher._id, newVoucher).then((dataRes) => {
        if (dataRes.success) {
          //sau khi update thì load lại dữ liệu
          const index = props.listVoucherAll.findIndex((item) => item._id === newVoucher._id);
          props.listVoucherAll[index] = newVoucher;
          props.setListVoucherAll([...props.listVoucherAll]);

          const start = new Date(newVoucher.startDate).getTime();
          const end = new Date(newVoucher.endDate).getTime();
          const now = new Date().getTime();
          var newList = [];
          if (now < start) {
            var find = false;
            props.listVoucherBefore.map((item) => {
              if (item._id === newVoucher._id) {
                find = true;
                newList.push(newVoucher);
              } else {
                newList.push(item);
              }
            })
            if (!find) {
              //nếu không tìm thấy thì xóa ở những list khác
              const index = props.listVoucherAfter.findIndex((item) => item._id === newVoucher._id);
              if (index != -1) {
                props.listVoucherAfter.splice(index, 1);
                props.setListVoucherAfter([...props.listVoucherAfter]);
              } else {
                const index = props.listVoucherBetween.findIndex((item) => item._id === newVoucher._id);
                props.listVoucherBetween.splice(index, 1);
                props.setListVoucherBetween([...props.listVoucherBetween]);
              }
              props.setListVoucherBefore([...props.listVoucherBefore, newVoucher]);
            } else {
              props.setListVoucherBefore(newList);
            }
          } else if (now > start && now < end) {
            var find = false;
            props.listVoucherBetween.map((item) => {
              if (item._id === newVoucher._id) {
                find = true;
                newList.push(newVoucher);
              } else {
                newList.push(item);
              }
            });
            if (!find) {
              const index = props.listVoucherAfter.findIndex((item) => item._id === newVoucher._id);
              if (index != -1) {
                props.listVoucherAfter.splice(index, 1);
                props.setListVoucherAfter([...props.listVoucherAfter]);
              } else {
                const index2 = props.listVoucherBefore.findIndex((item) => item._id === newVoucher._id);
                props.listVoucherBefore.splice(index2, 1);
                props.setListVoucherBefore([...props.listVoucherBefore]);
              }
              props.setListVoucherBetween([...props.listVoucherBetween, newVoucher]);
            } else {
              props.setListVoucherBetween(newList);
            }
          }
          else {
            var find = false;
            props.listVoucherAfter.map((item) => {
              if (item._id === newVoucher._id) {
                find = true;
                newList.push(newVoucher);
              } else {
                newList.push(item);
              }
            })
            if (!find) {
              const index = props.listVoucherBefore.findIndex((item) => item._id === newVoucher._id);
              if (index != -1) {
                props.listVoucherBefore.splice(index, 1);
                props.setListVoucherBefore([...props.listVoucherBefore]);
              } else {
                const index = props.listVoucherBetween.findIndex((item) => item._id === newVoucher._id);
                props.listVoucherBetween.splice(index, 1);
                props.setListVoucherBetween([...props.listVoucherBetween]);
              }
              props.setListVoucherAfter([...props.listVoucherAfter, newVoucher]);
            } else {
              props.setListVoucherAfter(newList);
            }
          }
          enqueueSnackbar("Cập nhật thành công", { variant: "success" });

        } else {
          enqueueSnackbar("Đã có lỗi xảy ra", { variant: "error" });
        }
      }).catch((error) => {
        enqueueSnackbar("Đã có lỗi xảy ra", { variant: "error" });
      });
      setLoadingAdd(false);
      setOpenAddVoucher(false);
      setUpdate(false);
      setAnchorEl(null);
      setAnchorId(null);
    }
  }
  function formatDateTime(date) {
    const d = new Date(date);
    const year = d.getFullYear();
    const month = ('0' + (d.getMonth() + 1)).slice(-2);
    const day = ('0' + d.getDate()).slice(-2);
    const hours = ('0' + d.getHours()).slice(-2);
    const minutes = ('0' + d.getMinutes()).slice(-2);
    const seconds = ('0' + d.getSeconds()).slice(-2);
    return `${year}-${month}-${day}T${hours}:${minutes}`;
  }

  const handleEdit = (item) => {
    setUpdate(true);
    setOpenAddVoucher(true);
    setNewVoucher({
      ...item,
      startDate: formatDateTime(item.startDate),
      endDate: formatDateTime(item.endDate)
    });
  }

  const handleDelete = (item) => {
    setLoading(true);
    voucherAPI.delete(item._id).then((dataRes) => {
      if (dataRes.success) {
        const index = props.data.findIndex((item) => item._id === id);
        props.data.splice(index, 1);
        props.setListVoucherAll([...props.data]);

        const index2 = props.listVoucherAfter.findIndex((item) => item._id === id);
        if (index2) {
          props.listVoucherAfter.splice(index2, 1);
          props.setListVoucherAfter([...props.listVoucherAfter]);
        }

        const index3 = props.listVoucherBefore.findIndex((item) => item._id === id);
        if (index3) {
          props.listVoucherBefore.splice(index3, 1);
          props.setListVoucherBefore([...props.listVoucherBefore]);
        }

        const index4 = props.listVoucherBetween.findIndex((item) => item._id === id);
        if (index4) {
          props.listVoucherBetween.splice(index4, 1);
          props.setListVoucherBetween([...props.listVoucherBetween]);
        }
        setLoading(false);
        setAnchorEl(null);
        setAnchorId(null);
        enqueueSnackbar("Xóa voucher thành công", { variant: "success" });
      } else {
        setLoading(false);
        setAnchorEl(null);
        setAnchorId(null);
        enqueueSnackbar("Xóa thất bại", { variant: "error" });
      }
    })
      .catch((e) => {
        setLoading(false);
        setAnchorEl(null);
        setAnchorId(null);
        enqueueSnackbar("Xóa thất bại", { variant: "error" });
      });
  }

  const handleChange = (e) => {
    const { name, value } = e.target;
    setNewVoucher({ ...newVoucher, [name]: value });
  };

  const open = Boolean(anchorId);

  const handleClick = (event) => {
    setAnchorEl(event.currentTarget);
  };

  const handleClose = () => {
    setAnchorId(null);
  };



  const renderBody = (item, index) => (
    <tr key={index}>
      <td>{index + 1}</td>
      <td>
        {item._id}{" "}
      </td>
      <td style={{ minWidth: "100px" }}>
        {item.code}
      </td>
      <td style={{ minWidth: "100px" }}>
        {item.type === "Product" ? "Thú cưng" : item.type === "Shipping" ? "Vận chuyển" : "Tổng hóa đơn"}
      </td>
      <td style={{ textAlign: 'center', minWidth: '70px' }}>{item.discount} %</td>
      <td style={{ textAlign: 'end' }}>{item.maxDiscount.toLocaleString()}</td>
      <td>{new Date(item.startDate).toLocaleString()}</td>
      <td>{new Date(item.endDate).toLocaleString()}</td>
      <td style={{ textAlign: 'end' }}>{item.quantity}</td>
      <td style={{ textAlign: 'end' }}>{item.used}</td>
      <td>{item.status}</td>
      <td>
        <IconButton
          aria-label="more"
          aria-controls="long-menu"
          aria-haspopup="true"
          onClick={(e) => {
            handleClick(e);
            setAnchorId(item);
          }}
        >
          <MoreVertIcon />
        </IconButton>
        <Menu
          id="long-menu"
          anchorEl={anchorEl}
          keepMounted
          open={open}
          onClose={handleClose}
          PaperProps={{
            style: {
              backgroundColor: 'white', // Set to any color you prefer
            },
          }}
        >
          <MenuItem onClick={() => { handleEdit(anchorId); }}>Chỉnh sửa</MenuItem>
          <MenuItem onClick={() => { handleDelete(anchorId); }}>Xóa</MenuItem>
        </Menu>

      </td>
    </tr>
  );

  return (
    <div>
      <div style={{ textAlign: "left" }}>
        <button style={{
          backgroundColor: 'blue',
          color: 'white',
          padding: '10px 20px',
          border: 'none',
          borderRadius: '5px',
          cursor: 'pointer',
          fontSize: '16px',
          margin: '10px'
        }}
          onClick={() => {
            setOpenAddVoucher(true);
          }}>Thêm voucher</button>
      </div>
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
      <Dialog open={openAddVoucher} onClose={() => {
        setOpenAddVoucher(false); setNewVoucher({
          code: '',
          type: '',
          discount: '',
          maxDiscount: '',
          startDate: '',
          endDate: '',
          quantity: '',
          used: 0,
          status: '',
          createdBy: ''
        });
      }}>
        <DialogTitle>Thêm mới thú cưng</DialogTitle>
        <DialogContent>
          {loadingAdd ? (
            <CircularProgress />
          ) : (
            <>

              <div style={{ display: "flex" }}>
                <TextField
                  margin="dense"
                  id="code"
                  name="code"
                  label="Mã voucher"
                  type="text"
                  fullWidth
                  variant="outlined"
                  value={newVoucher.code}
                  onChange={handleChange}
                  style={{ marginRight: "10px" }}
                />
                <FormControl fullWidth variant="outlined" margin="dense">
                  <Select
                    native
                    value={newVoucher.type}
                    onChange={handleChange}
                    inputProps={{
                      name: 'type',
                      id: 'type',
                    }}

                  >
                    <option aria-label="None" value="" disabled>Loại voucher</option>
                    <option value="Product">Thú cưng</option>
                    <option value="Shipping">Vận chuyển</option>
                    <option value="Total">Tổng đơn hàng</option>
                  </Select>
                </FormControl>
              </div>
              <div style={{ display: "flex" }}>
                <TextField
                  margin="dense"
                  id="discount"
                  name="discount"
                  label="Giảm (%)"
                  type="percent"
                  fullWidth
                  variant="outlined"
                  value={newVoucher.discount}
                  onChange={handleChange}
                  style={{ marginRight: "10px" }}
                />

                <TextField
                  margin="dense"
                  id="maxDiscount"
                  name="maxDiscount"
                  label="Giảm tối đa (VND)"
                  type="number"
                  fullWidth
                  variant="outlined"
                  value={newVoucher.maxDiscount}
                  onChange={handleChange}
                />
              </div>
              <div style={{ display: "flex" }}>
                <TextField
                  margin="dense"
                  id="startDate"
                  name="startDate"
                  label="Ngày bắt đầu"
                  type="datetime-local"
                  fullWidth
                  variant="outlined"
                  InputLabelProps={{
                    shrink: true,
                  }}
                  value={newVoucher.startDate}
                  onChange={handleChange}
                />
                <TextField
                  style={{ marginLeft: "10px" }}
                  margin="dense"
                  id="endDate"
                  name="endDate"
                  label="Ngày kết thúc"
                  type="datetime-local"
                  fullWidth
                  variant="outlined"
                  InputLabelProps={{
                    shrink: true,
                  }}
                  value={newVoucher.endDate}
                  onChange={handleChange}
                />
              </div>
              <div style={{ display: "flex" }}>
                <TextField
                  margin="dense"
                  id="quantity"
                  name="quantity"
                  label="Số lượng"
                  type="number"
                  fullWidth
                  variant="outlined"
                  value={newVoucher.quantity}
                  onChange={handleChange}
                />
                <FormControl fullWidth variant="outlined" margin="dense">
                  <Select
                    native
                    value={newVoucher.status}
                    onChange={handleChange}
                    inputProps={{
                      name: 'status',
                      id: 'status',
                    }}

                  >
                    <option aria-label="None" value="" disabled>Trạng thái</option>
                    <option value="active">Hoạt động</option>
                    <option value="non-active">Không hoạt động</option>
                  </Select>
                </FormControl>
              </div>
              <Button onClick={() => { handleSave() }} color="primary" variant="contained" style={{ marginTop: '20px' }}>
                Lưu
              </Button>
              <Button onClick={() => {
                setOpenAddVoucher(false); setNewVoucher({
                  code: '',
                  type: '',
                  discount: '',
                  maxDiscount: '',
                  startDate: '',
                  endDate: '',
                  quantity: '',
                  used: 0,
                  status: '',
                  createdBy: ''
                });
              }} style={{ marginLeft: "20px" }}>Đóng</Button>
            </>
          )}
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

export default Voucher;
