import React from 'react';
import './NavbarCenter.scss';
import userMenus from '~/mockdata/user_menus.json';
import { useSelector } from 'react-redux';
import { useLocation, Link } from 'react-router-dom';
import Dropdown from '~/components/Center/DropdownCenter/DropdownCenter';

const renderUserToggle = (user) => (
    <div className="topnav__right-user">
        <div className="topnav__right-user__image">
            <img src={user?.image} alt="" />
        </div>
        <div className="topnav__right-user__name">{user?.display_name}</div>
    </div>
);

const renderUserMenu = (item, index) => (
    <Link to="/" key={index}>
        <div className="notification-item">
            <i className={item.icon}></i>
            <span>{item.content}</span>
        </div>
    </Link>
);

const NavbarCenter = () => {
    const userLogin = useSelector((state) => state.user);
    const location = useLocation();

    const currentUser = {
        displayName: JSON.parse(localStorage.getItem('user')).name,
        image: JSON.parse(localStorage.getItem('user')).avatar
    };

    return (
        <div className="topnav-admin">
            <div style={{ marginTop: '20px' }}>{/* <FilterAdmin /> */}</div>

            <div className="topnav__right">
                <div className="topnav__right-item">
                    {/* dropdown here */}
                    <Dropdown
                        customToggle={() => renderUserToggle(currentUser)}
                        contentData={userMenus}
                        renderItems={(item, index) => renderUserMenu(item, index)}
                    />
                </div>
                <div className="topnav__right-item">{/* <ThemeMenu /> */}</div>
            </div>
        </div>
    );
};

export default NavbarCenter;
