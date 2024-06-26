import "./ManageOrder.scss";
import React, { useState } from "react";
import Box from "@mui/material/Box";
import Tab from "@mui/material/Tab";
import TabContext from "@mui/lab/TabContext";
import TabList from "@mui/lab/TabList";
import TabPanel from "@mui/lab/TabPanel";
import Order from "./order";

const ManageOrder = (props) => {
  const [value, setValue] = useState("1");

  const handleChange = (event, newValue) => {
    setValue(newValue);
  };

  return (
    <div className="user__admin">
      <div className="header__customer">
        <h2 className="page-header">Quản lý đơn hàng</h2>
      </div>
      <div>
        <TabContext value={value}>
          <Box sx={{ borderBottom: 1, borderColor: "divider" }}>
            <TabList onChange={handleChange} aria-label="lab API tabs example">
              <Tab label="Chờ xác nhận" value="1" />
              <Tab label="Đã xác nhận" value="2" />
              <Tab label="Đang vận chuyển" value="3" />
              <Tab label="Đã vận chuyển" value="4" />
              <Tab label="Hoàn thành" value="5" />
              <Tab label="Hủy" value="6" />
            </TabList>
          </Box>
          <TabPanel value="1">
            <Order
              data={props.dataPD}
              setListOrderPD={props.setListOrderPD}
              listOrderCF={props.dataCF}
              setListOrderCF={props.setListOrderCF}
              listOrderDLING={props.dataDLING}
              setListOrderDLING={props.setListOrderDLING}
              listOrderDLED={props.dataDLED}
              setListOrderDLED={props.setListOrderDLED}
              listOrderCPL={props.dataCPL}
              setListOrderCPL={props.setListOrderCPL}
              listOrderCC={props.dataCC}
              setListOrderCC={props.setListOrderCC}
            />
          </TabPanel>
          <TabPanel value="2">
            <Order data={props.dataCF}
              setListOrderPD={props.setListOrderPD}
              listOrderCF={props.dataCF}
              setListOrderCF={props.setListOrderCF}
              listOrderDLING={props.dataDLING}
              setListOrderDLING={props.setListOrderDLING}
              listOrderDLED={props.dataDLED}
              setListOrderDLED={props.setListOrderDLED}
              listOrderCPL={props.dataCPL}
              setListOrderCPL={props.setListOrderCPL}
              listOrderCC={props.dataCC}
              setListOrderCC={props.setListOrderCC} />
          </TabPanel>
          <TabPanel value="3">
            <Order
              data={props.dataDLING}
              setListOrderPD={props.setListOrderPD}
              listOrderCF={props.dataCF}
              setListOrderCF={props.setListOrderCF}
              listOrderDLING={props.dataDLING}
              setListOrderDLING={props.setListOrderDLING}
              listOrderDLED={props.dataDLED}
              setListOrderDLED={props.setListOrderDLED}
              listOrderCPL={props.dataCPL}
              setListOrderCPL={props.setListOrderCPL}
              listOrderCC={props.dataCC}
              setListOrderCC={props.setListOrderCC}
            />
          </TabPanel>
          <TabPanel value="4">
            <Order
              data={props.dataDLED}
              setListOrderPD={props.setListOrderPD}
              listOrderCF={props.dataCF}
              setListOrderCF={props.setListOrderCF}
              listOrderDLING={props.dataDLING}
              setListOrderDLING={props.setListOrderDLING}
              listOrderDLED={props.dataDLED}
              setListOrderDLED={props.setListOrderDLED}
              listOrderCPL={props.dataCPL}
              setListOrderCPL={props.setListOrderCPL}
              listOrderCC={props.dataCC}
              setListOrderCC={props.setListOrderCC}
            />
          </TabPanel>
          <TabPanel value="5">
            <Order
              data={props.dataCPL}
              setListOrderPD={props.setListOrderPD}
              listOrderCF={props.dataCF}
              setListOrderCF={props.setListOrderCF}
              listOrderDLING={props.dataDLING}
              setListOrderDLING={props.setListOrderDLING}
              listOrderDLED={props.dataDLED}
              setListOrderDLED={props.setListOrderDLED}
              listOrderCPL={props.dataCPL}
              setListOrderCPL={props.setListOrderCPL}
              listOrderCC={props.dataCC}
              setListOrderCC={props.setListOrderCC}
            />
          </TabPanel>
          <TabPanel value="6">
            <Order
              data={props.dataCC}
              setListOrderPD={props.setListOrderPD}
              listOrderCF={props.dataCF}
              setListOrderCF={props.setListOrderCF}
              listOrderDLING={props.dataDLING}
              setListOrderDLING={props.setListOrderDLING}
              listOrderDLED={props.dataDLED}
              setListOrderDLED={props.setListOrderDLED}
              listOrderCPL={props.dataCPL}
              setListOrderCPL={props.setListOrderCPL}
              listOrderCC={props.dataCC}
              setListOrderCC={props.setListOrderCC}
            />
          </TabPanel>
        </TabContext>
      </div>
    </div>
  );
};

export default ManageOrder;
