import React from 'react';
import SidebarData from '~/mockdata/sidebarDataCenter';
import SidebarItem from '~/components/Center/Sidebar/SidebarItem';
import { Link, useLocation, useNavigate } from 'react-router-dom';
import './Sidebar.scss';
import logo from '~/assets/img/dog_banner.png';

const Sidebar = () => {
    const location = useLocation();
    const activeItem = SidebarData.All.findIndex((item) => item.route === location.pathname);
    const navigate = useNavigate();


    const handleHome = () => {
        navigate('/');
    };
    const handleResetSearchText = () => {};
    return (
        <div className="sidebar">
            <div className="sidebar__logo" onClick={handleHome}>
                <img src={logo} alt="company logo" />
            </div>

            {/* <p className="sub__header">Tổng quan</p>
            {SidebarData.Overview.map((item, index) => (
                <Link to={item.route} key={item.id} onClick={handleResetSearchText}>
                    <SidebarItem title={item.display_name} icon={item.icon} active={item.id === activeItem} />
                </Link>
            ))} */}
            <p className="sub__header">Trung tâm</p>
            {SidebarData.Manage.map((item, index) => (
                <Link to={item.route} key={item.id} onClick={handleResetSearchText}>
                    <SidebarItem title={item.display_name} icon={item.icon} active={item.id === activeItem} />
                </Link>
            ))}

            {/* <p className="sub__header">Cài đặt</p>
            {SidebarData.Setting.map((item, index) => (
                <Link to={item.route} key={item.id} onClick={handleResetSearchText}>
                    <SidebarItem title={item.display_name} icon={item.icon} active={item.id === activeItem} />
                </Link>
            ))} */}
        </div>
    );
};

export default Sidebar;
