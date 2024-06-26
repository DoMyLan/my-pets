import React, { Suspense } from "react";
import { Routes, Route } from "react-router-dom";
import LayoutAdmin from "~/pages/admin/LayoutAdmin/LayoutAdmin";
import LayoutCenter from "~/pages/center/LayoutCenter/LayoutCenter";
import Login from "~/pages/Login/Login";

const Auth = () => {
  return (
    <Routes>
      <Route path="*" element={<Suspense></Suspense>} />
      <Route path="/login" element={<Login />} />
      <Route path="/admin/*" element={<LayoutAdmin />} />
      <Route path="/center/*" element={<LayoutCenter />} />
    </Routes>
  );
};
export default Auth;
