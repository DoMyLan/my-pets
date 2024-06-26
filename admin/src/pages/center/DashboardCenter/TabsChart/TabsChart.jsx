// import * as React from 'react';
// import Chart from 'react-apexcharts';
// import { useSelector } from 'react-redux';
// import Box from '@mui/material/Box';
// import Tab from '@mui/material/Tab';
// import Tabs from '@mui/material/Tabs';
// import Typography from '@mui/material/Typography';
// import { RootState } from '../../../redux/store';

// import summaryHomeApi from '~/services/apis/partnerAPI/summaryHostApi';
// import { revenueStatisticsResponse } from '../../../share/models/statisticAdmin';
// import './TabsChart.scss';

// function TabPanel(props) {
//     const { children, value, index, ...other } = props;

//     return (
//         <div
//             role="tabpanel"
//             hidden={value !== index}
//             id={`vertical-tabpanel-${index}`}
//             aria-labelledby={`vertical-tab-${index}`}
//             {...other}
//             style={{ width: '100%' }}
//         >
//             {value === index && (
//                 <Box sx={{ padding: '6px 16px 0px 16px', height: '100%' }}>
//                     <Typography sx={{ height: '100%' }}>{children}</Typography>
//                 </Box>
//             )}
//         </div>
//     );
// }

// const TabsChart = () => {
//     return (
//         <div className="tabs-chart">
//             <Box sx={{ flexGrow: 1, bgcolor: 'background.paper', display: 'flex', height: '100%' }}>
//                 <Tabs
//                     orientation="vertical"
//                     variant="scrollable"
//                     value={value}
//                     onChange={handleChange}
//                     aria-label="Vertical tabs example"
//                     sx={{ borderRight: 1, borderColor: 'divider' }}
//                 >
//                     <Tab
//                         label="Đặt phòng"
//                         {...a11yProps(0)}
//                         sx={{ textTransform: 'none', padding: '5px', fontSize: '12px', fontFamily: 'Roboto' }}
//                     />
//                     <Tab
//                         label="Doanh thu"
//                         {...a11yProps(1)}
//                         sx={{ textTransform: 'none', padding: '5px', fontSize: '12px', fontFamily: 'Roboto' }}
//                     />
//                 </Tabs>
//                 <TabPanel value={value} index={0}>
//                     <div className="card-admin-chart" style={{ height: '100%' }}>
//                         <Chart
//                             options={
//                                 themeReducer.mode === 'theme-mode-dark'
//                                     ? {
//                                           ...chartOptions.options,
//                                           theme: { mode: 'dark' }
//                                       }
//                                     : {
//                                           ...chartOptions.options,
//                                           theme: { mode: 'light' }
//                                       }
//                             }
//                             // options={chartOptions.options}
//                             series={chartOptions.series}
//                             type="line"
//                             height="100%"
//                             width="100%"
//                         />
//                     </div>
//                 </TabPanel>
//                 <TabPanel value={value} index={1}>
//                     <div className="card-admin-chart">
//                         <Chart
//                             options={
//                                 themeReducer.mode === 'theme-mode-dark'
//                                     ? {
//                                           ...chartOptionsRevenue.options,
//                                           theme: { mode: 'dark' }
//                                       }
//                                     : {
//                                           ...chartOptionsRevenue.options,
//                                           theme: { mode: 'light' }
//                                       }
//                             }
//                             // options={chartOptions.options}
//                             series={chartOptionsRevenue.series}
//                             type="line"
//                             height="100%"
//                             width="100%"
//                         />
//                     </div>
//                 </TabPanel>
//             </Box>
//         </div>
//     );
// };

// export default TabsChart;
