import { useSnackbar } from "notistack";

import Table from "~/components/Table/Table";
import "./Pets.scss";

import { useState } from "react";
import CircularProgress from "@material-ui/core/CircularProgress";
import MoreVertIcon from '@mui/icons-material/MoreVert';
// import CloseIcon from '@mui/icons-material/Close';
import { Dialog, Chip, InputLabel, OutlinedInput, DialogContent, Avatar, MenuItem, IconButton, Menu, DialogTitle, TextField, Button, Select, FormControl } from "@material-ui/core";
import petAPI from "~/services/apis/petAPI/petAPI";
import uploadAPI from "~/services/apis/uploadAPI";

const customerTableHead = [
  "STT",
  "Hình ảnh",
  "Tên",
  "Loại",
  "Giống",
  "Giá (VND)",
  "Giảm giá (VND)",
  "Trạng thái",
  "Hành động",
];

const renderHead = (item, index) => <th key={index}>{item}</th>;

const Pets = (props) => {
  const { enqueueSnackbar } = useSnackbar();
  const [loading, setLoading] = useState(false);
  const [loadingAdd, setLoadingAdd] = useState(false);
  const [loadingUpdate, setLoadingUpdate] = useState(false);
  const [anchorEl, setAnchorEl] = useState(null);
  const [petDetail, setPetDetail] = useState(null);
  const [anchorId, setAnchorId] = useState(null);
  const [openAdd, setOpenAdd] = useState(null);
  const [openUpdate, setOpenUpdate] = useState(null);
  const [openDetail, setOpenDetail] = useState(false);
  const [selectedFiles, setSelectedFiles] = useState([]);
  const [imagePreviews, setImagePreviews] = useState([]);
  const [discountPrice, setDiscountPrice] = useState(0);
  const [startDate, setStartDate] = useState('');
  const [endDate, setEndDate] = useState('');
  const [openReduce, setOpenReduce] = useState(false);
  const [newPet, setNewPet] = useState({
    centerId: '',
    namePet: '',
    petType: '',
    breed: '',
    price: '',
    images: [],
    color: [],
    gender: '',
    weight: '',
    free: false,
    birthday: '',
    original: '',
    instruction: '',
    attention: '',
    hobbies: '',
    inoculation: '',
  });

  const colors = ['Red', 'Orange', 'Yellow', 'Green', 'Blue', 'Indigo', 'Violet'];

  const open = Boolean(anchorEl);

  const handleOpenAdd = () => {
    setOpenAdd(true);
  }

  const handleDelete = (petId) => {
    setLoading(true);
    petAPI.deletePet(petId).then((dataRes) => {
      const index = props.data.findIndex((item) => item._id === petId);
      props.data.splice(index, 1);
      props.setListPet([...props.data]);
      enqueueSnackbar('Xóa thú cưng thành công', { variant: 'success' });
      setLoading(false);
      setAnchorEl(null);
    }).catch((error) => {
      enqueueSnackbar('Xóa thú cưng thất bại', { variant: 'error' });
    });
  }

  const handleReducePrice = (petId) => {
    setLoading(true);
    petAPI.getPetById(petId).then((dataRes) => {
      setPetDetail(dataRes.data);
      setAnchorEl(null);
      setOpenReduce(true);
      setLoading(false);
    }).catch((error) => { });
  }

  const handleReduce = () => {
    if (discountPrice < 0) {
      enqueueSnackbar('Giảm giá không được nhỏ hơn 0', { variant: 'error' });
      return;
    }
    if (startDate == '' || endDate == '') {
      enqueueSnackbar('Vui lòng chọn ngày bắt đầu và kết thúc', { variant: 'error' });
      return;
    }
    setLoadingUpdate(true);
    petAPI.updatePet(petDetail._id, { reducePrice: discountPrice, dateStartReduce: startDate, dateEndReduce: endDate }).then((dataRes) => {
      enqueueSnackbar('Giảm giá thú cưng thành công', { variant: 'success' });
      setLoadingUpdate(false);
      setOpenReduce(false);
    }).catch((error) => {
      enqueueSnackbar('Giảm giá thú cưng thất bại', { variant: 'error' });
    });
  }

  const handleOpenUpdate = (petId) => {
    setLoading(true);
    setOpenUpdate(true);
    petAPI.getPetById(petId).then((dataRes) => {
      setNewPet({ ...dataRes.data, birthday: new Date(dataRes.data.birthday).toISOString().split('T')[0] });

      setAnchorEl(null);
      setImagePreviews(dataRes.data.images);
      setOpenAdd(true);
      setLoading(false);
    }).catch((error) => { });

  }

  const handleFileChange = (event) => {
    setSelectedFiles(event.target.files);
    const filesArray = Array.from(event.target.files);
    const urls = filesArray.map(file => URL.createObjectURL(file));
    setImagePreviews(urls);
  };

  const handleClick = (event) => {
    setAnchorEl(event.currentTarget);
  };
  const handleClose = () => {
    setAnchorEl(null);
    setOpenDetail(false);
  };

  const handleChange = (e) => {
    const { name, value } = e.target;
    setNewPet({ ...newPet, [name]: value });
  };

  const handleColorChange = (event) => {
    const {
      target: { value },
    } = event;
    setNewPet({ ...newPet, color: typeof value === 'string' ? value.split(',') : value });
  };

  const handleSave = async () => {
    //kiểm tra các trường không được trống hoặc ''
    if (newPet.namePet == '' || newPet.petType == '' || newPet.breed == '' || newPet.price == '' || newPet.weight == '' || newPet.birthday == '' || newPet.original == '' || newPet.instruction == '' || newPet.attention == '' || newPet.hobbies == '' || newPet.inoculation == '' || newPet.images.length == 0) {
      enqueueSnackbar('Vui lòng nhập đầy đủ thông tin', { variant: 'error' });
      return;
    }
    if (newPet.price < 0 || newPet.reducePrice < 0 || newPet.weight < 0) {
      enqueueSnackbar('Giá, giảm giá, cân nặng không được nhỏ hơn 0', { variant: 'error' });
      return;
    }
    if (newPet.price == 0) {
      newPet.free = true;
    }
    const center = JSON.parse(localStorage.getItem('user'));
    newPet.centerId = center._id;

    setLoadingAdd(true);

    try {
      openUpdate ? petAPI.updatePet(newPet._id, newPet).then((dataRes) => {
        const index = props.data.findIndex((item) => item._id === newPet._id);
        props.data[index] = newPet;
        props.setListPet([...props.data]);
        enqueueSnackbar('Cập nhật thú cưng thành công', { variant: 'success' });
        setLoadingAdd(false);
        setOpenUpdate(false);
        setOpenAdd(false);
      }).catch((error) => { }) :
        petAPI.addPet(newPet).then((dataRes) => {
          props.setListPet([...props.data, dataRes.pet]);
          enqueueSnackbar('Thêm thú cưng thành công', { variant: 'success' });
          setLoadingAdd(false);
        }).catch((error) => {
          enqueueSnackbar('Thêm thú cưng thất bại', { variant: 'error' });
        });
    } catch (error) {
      enqueueSnackbar('Thêm thú cưng thất bại', { variant: 'error' });
    } finally {
      setLoadingAdd(false);
    }
  };

  const handleUploadImage = () => {
    setLoading(true);
    uploadAPI.uploadMulti(selectedFiles).then((dataRes) => {
      ///đôi images thành ["dshfg", "shgdjf"]
      var images = [];
      for (let i = 0; i < dataRes.length; i++) {
        images.push(dataRes[i].url);
      }
      setNewPet({ ...newPet, images: images });
      setLoading(false);
    }).catch((e) => { });
  }

  const handleViewDetail = (petId) => {
    setLoading(true);
    petAPI.getPetById(petId).then((dataRes) => {
      setPetDetail(dataRes.data);
      setAnchorEl(null);
      setLoading(false);
      setOpenDetail(true);
    }).catch((error) => { });
  }



  const renderBody = (item, index) => (
    <tr key={index}>
      <td>{index + 1}</td>
      <td>
        <Avatar className="avatar" alt="Cindy Baker" src={item.images[0]} />
      </td>
      <td>
        {item.namePet}
      </td>
      <td>{item.petType == "Dog" ? "Chó" : "Mèo"}</td>
      <td>{item.breed}</td>
      <td style={{ textAlign: "right" }}>{item.price == 0 ? <span style={{ color: 'green' }}>Miễn phí</span> : parseInt(item.price).toLocaleString()}</td>
      <td style={{ textAlign: "right" }}>{parseInt(item.reducePrice).toLocaleString()}</td>
      <td style={{
        color: item.statusPaid === "NOTHING" ? "red" :
          item.statusPaid === "PENDING" ? "orange" : "green"
      }}>
        {item.statusPaid === "NOTHING" ? "Chưa bán" :
          item.statusPaid === "PENDING" ? "Đang xử lý" : "Đã bán"}
      </td>
      <td>
        <IconButton
          aria-label="more"
          aria-controls="long-menu"
          aria-haspopup="true"
          onClick={(e) => {
            handleClick(e);
            setAnchorId(item._id);
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
          <MenuItem onClick={() => {
            handleViewDetail(anchorId);
          }}>Chi tiết</MenuItem>
          <MenuItem onClick={() => { handleOpenUpdate(anchorId); }}>Chỉnh sửa</MenuItem>
          <MenuItem onClick={() => { handleReducePrice(anchorId); }}>Giảm giá</MenuItem>
          <MenuItem onClick={() => { handleDelete(anchorId); }}>Xóa</MenuItem>
        </Menu>

      </td>
    </tr >
  );

  return (
    <div className="user__admin">
      <div className="header__customer">
        <h2 className="page-header">Quản lý thú cưng</h2>
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
            setOpenAdd(true);
          }}>Thêm thú cưng</button>
      </div>

      <div className="row">
        <div className="col l-12">
          <div className="card-admin">
            <div className="card__body">
              <Table
                limit="10"
                headData={customerTableHead}
                renderHead={(item, index) => renderHead(item, index)}
                bodyData={props?.data}
                renderBody={(item, index) => renderBody(item, index)}
              />
            </div>
            <Dialog open={loading} onClose={loading}>
              <DialogContent >
                {loading && <CircularProgress />}
              </DialogContent>
            </Dialog>
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
              <p style={{ margin: "10px 0" }}>Giới tính: {petDetail.gender == "MALE" ? "Giống đực" : "Giống cái"}</p>
              <p style={{ margin: "10px 0" }}>Cân nặng: {petDetail.weight} Kg</p>
              <p style={{ margin: "10px 0" }}>Nguồn gốc: {petDetail.original}</p>
              <p style={{ margin: "10px 0" }}>Hướng dẫn chăm sóc: {petDetail.instruction}</p>
              <p style={{ margin: "10px 0" }}>Chú ý: {petDetail.attention}</p>
              <p style={{ margin: "10px 0" }}>Sở thích: {petDetail.hobbies}</p>
              <p style={{ margin: "10px 0" }}>Tình trạng tiêm chủng: {petDetail.inoculation}</p>
              <p style={{ margin: "10px 0" }}>Tình trạng: {petDetail.statusPaid == "NOTHING" ? "Chưa bán" : petDetail.statusPaid == "PENDING" ? "Đang xử lý" : "Đã bán"}</p>
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
      <Dialog open={openAdd} onClose={() => {
        setOpenAdd(false); setNewPet({
          centerId: '',
          namePet: '',
          petType: '',
          breed: '',
          price: '',
          images: [],
          color: [],
          gender: '',
          weight: '',
          free: false,
          birthday: '',
          original: '',
          instruction: '',
          attention: '',
          hobbies: '',
          inoculation: '',
        });
        setSelectedFiles([]);
        setImagePreviews([]);
      }}>
        <DialogTitle>Thêm mới thú cưng</DialogTitle>
        <DialogContent>
          {loadingAdd ? (
            <CircularProgress />
          ) : (
            <>
              <TextField
                margin="dense"
                id="namePet"
                name="namePet"
                label="Tên thú cưng"
                type="text"
                fullWidth
                variant="outlined"
                value={newPet.namePet}
                onChange={handleChange}
              />
              <div style={{ display: "flex" }}>
                <FormControl fullWidth variant="outlined" margin="dense">
                  <Select
                    native
                    value={newPet.petType}
                    onChange={handleChange}
                    inputProps={{
                      name: 'petType',
                      id: 'petType',
                    }}
                    style={{ marginRight: "10px" }}
                  >
                    <option aria-label="None" value="" disabled>Loại Thú Cưng</option>
                    <option value="Dog">Chó</option>
                    <option value="Cat">Mèo</option>
                  </Select>
                </FormControl>
                <FormControl fullWidth variant="outlined" margin="dense">
                  <Select
                    native
                    value={newPet.breed}
                    onChange={handleChange}
                    inputProps={{
                      name: 'breed',
                      id: 'breed',
                    }}
                    style={{ marginRight: "10px" }}
                  >
                    <option aria-label="None" value="" disabled>Giống</option>
                    {
                      newPet.petType == 'Dog' ? <>
                        <option value="Chó Alaska">Chó Alaska</option>
                        <option value="Chó Bắc Kinh">Chó Bắc Kinh</option>
                        <option value="Chó Beagle">Chó Beagle</option>
                        <option value="Chó Becgie">Chó Becgie</option>
                        <option value="Chó Chihuahua">Chó Chihuahua</option>
                        <option value="Chó Corgi">Chó Corgi</option>
                        <option value="Chó Dachshund">Chó Dachshund</option>
                        <option value="Chó Golden">Chó Golden</option>
                        <option value="Chó Husky">Chó Husky</option>
                        <option value="Chó Phốc Sóc">Chó Phốc Sóc</option>
                        <option value="Chó Poodle">Chó Poodle</option>
                        <option value="Chó Pug">Chó Pug</option>
                        <option value="Chó Samoyed">Chó Samoyed</option>
                        <option value="Chó Shiba">Chó Shiba</option>
                        <option value="Chó cỏ">Chó cỏ</option>
                        <option value="Chó khác">Chó khác</option></> : <>
                        <option value="Mèo Ba Tư">Mèo Ba Tư</option>
                        <option value="Mèo Ai Cập">Mèo Ai Cập</option>
                        <option value="Mèo Anh lông dài">Mèo Anh lông dài</option>
                        <option value="Mèo Xiêm">Mèo Xiêm</option>
                        <option value="Mèo Munchkin">Mèo Munchkin</option>
                        <option value="Mèo Ragdoll">Mèo Ragdoll</option>
                        <option value="Mèo Mướp">Mèo Mướp</option>
                        <option value="Mèo Vàng">Mèo Vàng</option>
                        <option value="Mèo Mun">Mèo Mun</option>
                        <option value="Mèo khác">Mèo khác</option>
                      </>
                    }
                  </Select>
                </FormControl>
                <FormControl fullWidth variant="outlined" margin="dense">
                  <Select
                    native
                    value={newPet.gender}
                    onChange={handleChange}
                    inputProps={{
                      name: 'gender',
                      id: 'gender',
                    }}
                  >
                    <option aria-label="None" value="" disabled>Loại Thú Cưng</option>
                    <option value="MALE">Giống đực</option>
                    <option value="FEMALE">Giống cái</option>
                  </Select>
                </FormControl>
              </div>
              <div style={{ display: "flex" }}>
                <TextField
                  margin="dense"
                  id="price"
                  name="price"
                  label="Giá (VND)"
                  type="number"
                  fullWidth
                  variant="outlined"
                  value={newPet.price}
                  onChange={handleChange}
                  style={{ marginRight: "10px" }}
                />

                <TextField
                  margin="dense"
                  id="weight"
                  name="weight"
                  label="Cân nặng (Kg)"
                  type="number"
                  fullWidth
                  variant="outlined"
                  value={newPet.weight}
                  onChange={handleChange}
                  style={{ marginRight: "10px" }}
                />
                <TextField
                  margin="dense"
                  id="birthday"
                  name="birthday"
                  label="Ngày sinh"
                  type="date"
                  fullWidth
                  variant="outlined"
                  InputLabelProps={{
                    shrink: true,
                  }}
                  value={newPet.birthday}
                  onChange={handleChange}
                /></div>
              <div style={{ display: "flex" }}>
                <FormControl variant="outlined" fullWidth margin="dense">
                  <InputLabel id="color-multiple-chip-label">Màu sắc</InputLabel>
                  <Select
                    labelId="color-multiple-chip-label"
                    id="color"
                    multiple
                    value={newPet.color}
                    onChange={handleColorChange}
                    input={<OutlinedInput id="select-multiple-chip" label="Màu sắc" />}
                    renderValue={(selected) => (
                      <div style={{ display: 'flex', flexWrap: 'wrap', gap: '10px' }}>
                        {selected.map((color) => (
                          <Chip key={color} label={color} />
                        ))}
                      </div>
                    )}
                    style={{ marginRight: "10px" }}
                  >
                    {colors.map((color) => (
                      <option key={color} value={color} style={{ background: newPet.color.includes(color) ? "lightgray" : "white" }}>
                        {color}
                      </option>
                    ))}
                  </Select>
                </FormControl>
                <TextField
                  margin="dense"
                  id="original"
                  name="original"
                  label="Nguồn gốc"
                  type="text"
                  fullWidth
                  variant="outlined"
                  value={newPet.original}
                  onChange={handleChange}
                /></div>
              <TextField
                margin="dense"
                id="instruction"
                name="instruction"
                label="Hướng dẫn chăm sóc"
                type="text"
                fullWidth
                multiline
                rows={2}
                variant="outlined"
                value={newPet.instruction}
                onChange={handleChange}
              />
              <TextField
                margin="dense"
                id="attention"
                name="attention"
                label="Chú ý"
                type="text"
                fullWidth
                multiline
                rows={2}
                variant="outlined"
                value={newPet.attention}
                onChange={handleChange}
              />
              <TextField
                margin="dense"
                id="hobbies"
                name="hobbies"
                label="Sở thích"
                multiline
                rows={2}
                type="text"
                fullWidth
                variant="outlined"
                value={newPet.hobbies}
                onChange={handleChange}
              />
              <TextField
                margin="dense"
                id="inoculation"
                name="inoculation"
                label="Tiêm chủng"
                multiline
                rows={2}
                type="text"
                fullWidth
                variant="outlined"
                value={newPet.inoculation}
                onChange={handleChange}
              />
              <input
                accept="image/*"
                style={{ display: 'none' }}
                id="raised-button-file"
                multiple
                type="file"
                onChange={handleFileChange}
              />
              <label htmlFor="raised-button-file">
                <Button variant="contained" component="span" style={{ marginTop: '20px' }}>
                  Chọn ảnh
                </Button>
              </label>
              <label>
                <Button onClick={() => { handleUploadImage() }} variant="contained" component="span" style={{ marginTop: '20px', marginLeft: "20px", background: "blue", color: "white", fontWeight: "bold" }}>
                  Tải ảnh lên
                </Button>
              </label>
              <div style={{ marginTop: '20px' }}>
                {imagePreviews.map((imagePreview, index) => (
                  <img key={index} src={imagePreview} alt={`preview ${index}`} style={{ width: '100px', height: '100px', marginRight: '10px' }} />
                ))}
              </div>

              <Button onClick={() => { handleSave() }} color="primary" variant="contained" style={{ marginTop: '20px' }}>
                Lưu
              </Button>
              <Button onClick={() => {
                setOpenAdd(false); setNewPet({
                  centerId: '',
                  namePet: '',
                  petType: '',
                  breed: '',
                  price: '',
                  images: [],
                  color: [],
                  gender: '',
                  weight: '',
                  free: false,
                  birthday: '',
                  original: '',
                  instruction: '',
                  attention: '',
                  hobbies: '',
                  inoculation: '',
                });
                setSelectedFiles([]);
                setImagePreviews([]);
              }} style={{ marginLeft: "20px" }}>Đóng</Button>
            </>
          )}
        </DialogContent>
      </Dialog>
      <Dialog open={openReduce} onClose={() => { setOpenReduce(false); setDiscountPrice(0); setStartDate(''); setEndDate(''); }}>
        <DialogContent>
          {loadingUpdate ? (
            <CircularProgress />
          ) : (
            <>
              <h2>Giảm Giá Cho Thú Cưng</h2>
              <p>Tên: {petDetail?.namePet}</p>
              <p>Giống: {petDetail?.breed}</p>
              <div>
                {petDetail?.images.map((image, index) => (
                  <img key={index} src={image} alt="Pet" style={{ width: 100, height: 100, marginRight: 10 }} />
                ))}
              </div>
              <TextField
                margin="dense"
                label="Giá Giảm"
                value={discountPrice}
                onChange={(e) => setDiscountPrice(e.target.value)}
                fullWidth
                variant="outlined"
              />
              <TextField
                label="Ngày Bắt Đầu"
                type="date"
                value={startDate}
                onChange={(e) => setStartDate(e.target.value)}
                fullWidth
                margin="normal"
                variant="outlined"
                InputLabelProps={{
                  shrink: true,
                }}
              />
              <TextField
                label="Ngày Kết Thúc"
                type="date"
                value={endDate}
                onChange={(e) => setEndDate(e.target.value)}
                fullWidth
                margin="normal"

                variant="outlined"
                InputLabelProps={{
                  shrink: true,
                }}
              />
              <Button onClick={() => { handleReduce() }} color="primary" variant="contained" style={{ marginTop: '20px', marginRight: "30px" }}>
                Lưu
              </Button>
              <Button onClick={() => { setOpenReduce(false); setDiscountPrice(0); setStartDate(''); setEndDate(''); }} style={{ marginTop: "20px" }}>Đóng</Button></>)}
        </DialogContent>
      </Dialog>
    </div>
  );
};

export default Pets;
