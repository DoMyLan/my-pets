import { useState, useEffect, useContext } from "react";
import { useSnackbar } from "notistack";

import Voucher from "~/pages/center/LayoutVouchers/ManageVouchers";
import LoadingAdmin from "~/components/Admin/LoadingAdmin/LoadingAdmin"; 
import voucherAPI from "~/services/apis/managerCenter/voucherAPI";

const LayoutVouchers = () => {
  const { enqueueSnackbar } = useSnackbar();
  const [listVoucherAll, setListVoucherAll] = useState([]);
  const [listVoucherBefore, setListVoucherBefore] = useState([]);
  const [listVoucherBetween, setListVoucherBetween] = useState([]);
  const [listVoucherAfter, setListVoucherAfter] = useState([]);
  const [isLoading, setIsLoading] = useState(false);

  useEffect(() => {
    setIsLoading(true);

    voucherAPI.getVoucher(3).then((dataRes) => {
      //giảm đi 7h 
      dataRes.data.forEach((item) => {
        item.startDate = new Date(item.startDate).getTime() - 25200000;
        item.endDate = new Date(item.endDate).getTime() - 25200000;
      })


      setListVoucherAll(dataRes.data);
      setIsLoading(false);
    }).catch((error) => {
      enqueueSnackbar("Lấy danh sách voucher thất bại", { variant: "error" });
    });

    voucherAPI.getVoucher(0).then((dataRes) => {
      dataRes.data.forEach((item) => {
        item.startDate = new Date(item.startDate).getTime() - 25200000;
        item.endDate = new Date(item.endDate).getTime() - 25200000;
      })
      setListVoucherBefore(dataRes.data);
      setIsLoading(false);
    }).catch((error) => {
      enqueueSnackbar("Lấy danh sách voucher thất bại", { variant: "error" });
    });

    voucherAPI.getVoucher(1).then((dataRes) => {
      dataRes.data.forEach((item) => {
        item.startDate = new Date(item.startDate).getTime() - 25200000;
        item.endDate = new Date(item.endDate).getTime() - 25200000;
      })
      setListVoucherBetween(dataRes.data);
      setIsLoading(false);
    }).catch((error) => {
      enqueueSnackbar("Lấy danh sách voucher thất bại", { variant: "error" });
    });

    voucherAPI.getVoucher(2).then((dataRes) => {
      dataRes.data.forEach((item) => {
        item.startDate = new Date(item.startDate).getTime() - 25200000;
        item.endDate = new Date(item.endDate).getTime() - 25200000;
      })
      setListVoucherAfter(dataRes.data);
      setIsLoading(false);
    }).catch((error) => {
      enqueueSnackbar("Lấy danh sách voucher thất bại", { variant: "error" });
    });


  }, []);

  return (
    <>
      {isLoading ? (
        <LoadingAdmin />
      ) : (
        <Voucher
          dataAll={listVoucherAll}
          setListVoucherAll={setListVoucherAll}
          dataBefore={listVoucherBefore}
          setListVoucherBefore={setListVoucherBefore}
          dataBetween={listVoucherBetween}
          setListVoucherBetween={setListVoucherBetween}
          dataAfter={listVoucherAfter}
          setListVoucherAfter={setListVoucherAfter}
        />
      )}
    </>
  );
};

export default LayoutVouchers;
