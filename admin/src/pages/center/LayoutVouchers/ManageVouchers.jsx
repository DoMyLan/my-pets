import "./ManageVouchers.scss";
import React, { useState } from "react";
import Box from "@mui/material/Box";
import Tab from "@mui/material/Tab";
import TabContext from "@mui/lab/TabContext";
import TabList from "@mui/lab/TabList";
import TabPanel from "@mui/lab/TabPanel";
import Voucher from "./voucher";

const ManageVouchers = (props) => {
  const [value, setValue] = useState("1");

  const handleChange = (event, newValue) => {
    setValue(newValue);
  };

  return (
    <div className="user__admin">
      <div className="header__customer">
        <h2 className="page-header">Quản lý Voucher</h2>
      </div>
      <div>
        <TabContext value={value}>
          <Box sx={{ borderBottom: 1, borderColor: "divider" }}>
            <TabList onChange={handleChange} aria-label="lab API tabs example">
              <Tab label="Tất cả" value="1" />
              <Tab label="Chưa có hiệu lực" value="2" />
              <Tab label="Đang có hiệu lực" value="3" />
              <Tab label="Hết hiệu lực" value="4" />
            </TabList>
          </Box>
          <TabPanel value="1">
            <Voucher
              data={props.dataAll}
              setListVoucherAll={props.setListVoucherAll}
              listVoucherAll={props.dataAll}
              setListVoucherBefore={props.setListVoucherBefore}
              listVoucherBefore={props.dataBefore}
              setListVoucherBetween={props.setListVoucherBetween}
              listVoucherBetween={props.dataBetween}
              setListVoucherAfter={props.setListVoucherAfter}
              listVoucherAfter={props.dataAfter}
            />
          </TabPanel>
          <TabPanel value="2">
            <Voucher data={props.dataBefore}
              setListVoucherAll={props.setListVoucherAll}
              listVoucherAll={props.dataAll}
              setListVoucherBefore={props.setListVoucherBefore}
              listVoucherBefore={props.dataBefore}
              setListVoucherBetween={props.setListVoucherBetween}
              listVoucherBetween={props.dataBetween}
              setListVoucherAfter={props.setListVoucherAfter}
              listVoucherAfter={props.dataAfter} />
          </TabPanel>
          <TabPanel value="3">
            <Voucher
              data={props.dataBetween}
              setListVoucherAll={props.setListVoucherAll}
              listVoucherAll={props.dataAll}
              setListVoucherBefore={props.setListVoucherBefore}
              listVoucherBefore={props.dataBefore}
              setListVoucherBetween={props.setListVoucherBetween}
              listVoucherBetween={props.dataBetween}
              setListVoucherAfter={props.setListVoucherAfter}
              listVoucherAfter={props.dataAfter}
            />
          </TabPanel>
          <TabPanel value="4">
            <Voucher
              data={props.dataAfter}
              setListVoucherAll={props.setListVoucherAll}
              listVoucherAll={props.dataAll}
              setListVoucherBefore={props.setListVoucherBefore}
              listVoucherBefore={props.dataBefore}
              setListVoucherBetween={props.setListVoucherBetween}
              listVoucherBetween={props.dataBetween}
              setListVoucherAfter={props.setListVoucherAfter}
              listVoucherAfter={props.dataAfter}
            />
          </TabPanel>
        </TabContext>
      </div>
    </div>
  );
};

export default ManageVouchers;
