import React, { useState, useEffect } from "react";
import { useDispatch } from "react-redux";
import { useSnackbar } from "notistack";
import { useNavigate } from "react-router-dom";
import userSlice from "~/redux/userSlice";
import "./Login.scss";
import {
  Grid,
  Paper,
  Avatar,
  TextField,
  Button,
  Typography,
  Link,
  Dialog,
  DialogTitle,
  DialogContent,
  DialogContentText,
  DialogActions,
  CircularProgress,
} from "@material-ui/core";
import LockOutlinedIcon from "@material-ui/icons/LockOutlined";
import authAPI from "~/services/apis/adminAPI/authAPI";
const Login = () => {
  const dispatch = useDispatch();
  const paperStyle = {
    padding: 20,
    height: "70vh",
    width: 280,
    margin: "20px auto",
  };
  const avatarStyle = { backgroundColor: "#1bbd7e" };
  const btnstyle = { margin: "8px 0" };
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [messageError, setMessageError] = useState("");
  const { enqueueSnackbar } = useSnackbar();
  const navigate = useNavigate();
  const [open, setOpen] = React.useState(false);
  const [loading, setLoading] = useState(false);
  const [emailFP, setEmailFP] = useState("");

  const handleClickOpen = () => {
    setOpen(true);
  };

  const handleClose = () => {
    setOpen(false);
  };

  const handleLogin = async (event) => {
    event.preventDefault();
    if (!email) {
      setMessageError("Vui lòng nhập email!");
      return;
    } else if (!password) {
      setMessageError("Vui lòng nhập mật khẩu!");
      return;
    }
    setLoading(true);

    await authAPI.loginRequest({ email, password }).then((res) => {
      try {
        if (res.success && res.data.role === "ADMIN") {
          dispatch(userSlice.actions.signin(res.data));
          dispatch(userSlice.actions.setProfile(res.data));
          navigate("/admin");
        } else if (res.success && res.data.role === "CENTER") {
          dispatch(userSlice.actions.signin(res.data));
          dispatch(userSlice.actions.setProfile(res.data));
          navigate("/center");
        } else {
          if (res.success && res.data.role === "USER") {
            setMessageError("Không có quyền truy cập!");
          }
          setMessageError(res.message);

        }
      } catch (e) {
        setMessageError(e);
      }
    });
    setLoading(false);
  };

  const handleForgotPassword = async (event) => {
    event.preventDefault();
    handleClose();
    setLoading(true);
    await authAPI.forgotPassword({ email: emailFP }).then((res) => {
      try {
        if (res.success) {
          enqueueSnackbar(res.message, { variant: "success" });
        } else {
          enqueueSnackbar(res.message, { variant: "error" });
        }
      } catch (e) {
        enqueueSnackbar("Send email fail!", { variant: "error" });
      }
      setLoading(false);
    });
  };

  return (
    <Grid>
      <Paper elevation={10} style={paperStyle}>
        <Grid align="center">
          <Avatar style={avatarStyle}>
            <LockOutlinedIcon />
          </Avatar>
          <h2>Sign In</h2>
        </Grid>
        <TextField
          label="Email"
          placeholder="Nhập email"
          fullWidth
          required
          value={email}
          onChange={(e) => setEmail(e.target.value)}
        />
        <TextField
          label="Mật khẩu"
          placeholder="Nhập mật khẩu"
          type="password"
          fullWidth
          required
          value={password}
          onChange={(e) => setPassword(e.target.value)}
        />
        {messageError && <h5>{messageError}</h5>}
        {/* <FormControlLabel
          control={<Checkbox name="checkedB" color="primary" />}
          label="Remember me"
        /> */}
        <Button
          type="submit"
          onClick={handleLogin}
          color="primary"
          variant="contained"
          style={btnstyle}
          fullWidth
        >
          Đăng nhập
        </Button>
        <Typography>
          <Link href="#" onClick={handleClickOpen}>
            Quên mật khẩu?
          </Link>
        </Typography>
        <Dialog
          open={open}
          onClose={handleClose}
          aria-labelledby="form-dialog-title"
        >
          <DialogTitle id="form-dialog-title">Quên mật khẩu</DialogTitle>
          <DialogContent>
            <DialogContentText>
            Để đặt lại mật khẩu, vui lòng nhập địa chỉ email của bạn vào đây. Chúng tôi
            sẽ sớm gửi thông tin cập nhật.
            </DialogContentText>
            <TextField
              autoFocus
              margin="dense"
              id="name"
              label="Địa chỉ email"
              type="email"
              fullWidth
              value={emailFP}
              onChange={(e) => setEmailFP(e.target.value)}
            />
          </DialogContent>
          <DialogActions>
            <Button onClick={handleClose} color="primary">
              Hủy
            </Button>
            <Button onClick={handleForgotPassword} color="primary">
              Gửi
            </Button>
          </DialogActions>
        </Dialog>
        <DialogContent>{loading && <CircularProgress />}</DialogContent>
      </Paper>
    </Grid>
  );
};

export default Login;
