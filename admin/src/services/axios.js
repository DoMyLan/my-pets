import axios from "axios";
import { getToken, getRefreshToken, updateToken } from "./token";

// const API_BASE_URL = process.env.REACT_APP_API_BASE_URL;

const instance = axios.create({
  baseURL: "https://my-pets-api.vercel.app/api/v1",
  timeout: 10000,
  validateStatus: function (status) {
    return (status >= 200 && status < 400) || status != 401;
  },
});
instance.interceptors.request.use(
  (config) => {
    const token = getToken();

    if (token) {
      config.headers["Authorization"] = `Bearer ${token}`;
    }
    return config;
  },
  (error) => {
    return Promise.reject(error);
  }
);
instance.interceptors.response.use(
  (response) => response,
  async (error) => {
    const originalConfig = error?.config;

    if (error.response && error.response.status === 401) {
      const refreshToken = getRefreshToken();
      if (refreshToken) {
        try {
        //   originalConfig.headers["Authorization"] = `Bearer ${refreshToken}`;
          const response = await axios.post(
            "https://my-pets-api.vercel.app/api/v1/auth/refresh-token",
            {},
            { headers: { Authorization: `Bearer ${refreshToken}` } }
          );
          if (response.status === 200) {
            const acessToken = response.data.accessToken;
            updateToken(acessToken);
            originalConfig.headers["Authorization"] = `Bearer ${acessToken}`;
            return axios(originalConfig);
          } else {
            console.error(
              "Refresh token response is missing accessToken",
              response
            );
            return Promise.reject(error);
          }
        } catch (refreshError) {
          localStorage.removeItem("accessToken");
          localStorage.removeItem("refreshToken");
          localStorage.removeItem("persist:root");
          window.location.reload();
          console.error("Refresh token failed", refreshError);
          return Promise.reject(refreshError);
        }
      }
    }
    return Promise.reject(error);
  }
);
export default instance;
