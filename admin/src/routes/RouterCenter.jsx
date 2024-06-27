import { Routes, Route } from 'react-router-dom';
import DashboardCenter from '~/pages/center/DashboardCenter/DashboardCenter';
import LayoutPets from '~/pages/center/LayoutPets/LayoutPets';
import LayoutOrder from '~/pages/center/LayoutOrder/LayoutOrder';
import LayoutVouchers from '~/pages/center/LayoutVouchers/LayoutVouchers';
import LayoutWithTabs from '~/pages/center/LayoutRevenueStatistics/LayoutRevenue';

const RouterCenter = () => {
    return (
        <Routes>
            <Route path="/" element={<DashboardCenter />} />
            <Route path='/pets' element={<LayoutPets />} />
            <Route path='/orders' element={<LayoutOrder />} />
            <Route path='/voucher' element={<LayoutVouchers />} />
            <Route path='/revenue' element={<LayoutWithTabs />} />
            {/* <Route path="/typebeds" element={<LayoutTypeBedAdmin />} />
            <Route path="/facilities" element={<LayoutAmenityAdmin />} />
            <Route path="/facilitycategories" element={<LayoutTypeAmenityAdmin />} /> */}
        </Routes>
    );
};
export default RouterCenter;
