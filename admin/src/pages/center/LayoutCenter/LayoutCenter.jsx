import Sidebar from '~/components/Center/Sidebar/Sidebar';
import './LayoutCenter.scss';
import NavbarCenter from '~/components/Center/NavbarCenter/NavbarCenter';
import './boxicons-2.0.7/css/boxicons.min.css';
import RouterCenter from '~/routes/RouterCenter';
const LayoutCenter = () => {
    return (
        <div className="layout-admin">
            <div className={`layout`}>
                <Sidebar />
                <div className="layout__content">
                    <NavbarCenter />
                    <div className="layout__content-main">
                        <RouterCenter />
                    </div>
                </div>
            </div>
        </div>
    );
};
export default LayoutCenter;
