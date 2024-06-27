import React, { useState } from 'react';
import { AppBar, Tabs, Tab, Typography, Box } from '@material-ui/core';
import RevenueStatisticsPage from './RevenueStatisticsPage';
import RevenueStatisticsPageYM from './RevenueStatisticsYM';

function TabPanel(props) {
  const { children, value, index, ...other } = props;

  return (
    <div
      role="tabpanel"
      hidden={value !== index}
      id={`simple-tabpanel-${index}`}
      aria-labelledby={`simple-tab-${index}`}
      {...other}
    >
      {value === index && (
        <Box p={3}>
          <Typography>{children}</Typography>
        </Box>
      )}
    </div>
  );
}

function LayoutWithTabs() {
  const [value, setValue] = useState(0);

  const handleChange = (event, newValue) => {
    setValue(newValue);
  };

  return (
    <div>
      <AppBar position="static" style={{background:"grey"}}>
        <Tabs value={value} onChange={handleChange} >
          <Tab label="Tháng" style={{background:"white"}}/>
          <Tab label="Năm" style={{background:"white"}}/>
        </Tabs>
      </AppBar>
      <TabPanel value={value} index={0}>
        <RevenueStatisticsPageYM />
      </TabPanel>
      <TabPanel value={value} index={1}>
        <RevenueStatisticsPage />
      </TabPanel>
    </div>
  );
}

export default LayoutWithTabs;