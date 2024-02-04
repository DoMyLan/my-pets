import React from 'react';
import './NavbarAdmin.scss';
import userMenus from '~/mockdata/user_menus.json';
import { useSelector } from 'react-redux';
import { useLocation, Link } from 'react-router-dom';
import Dropdown from '~/components/Admin/DropdownAdmin/DropdownAdmin';

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

const NavbarAdmin = () => {
    const userLogin = useSelector((state) => state.user);
    const location = useLocation();

    const currentUser = {
        displayName: userLogin.current?.fullName,
        image: 'https://avatars.githubusercontent.com/u/102749812?s=400&u=3c7e5db86ba5ac72e8e035234afce6935803dacb&v=4'
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

export default NavbarAdmin;
