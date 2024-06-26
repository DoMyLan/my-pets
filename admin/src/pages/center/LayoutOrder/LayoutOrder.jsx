import { useState, useEffect, useContext } from "react";

import Order from "~/pages/center/LayoutOrder/ManageOrder";
import LoadingAdmin from "~/components/Admin/LoadingAdmin/LoadingAdmin";
import orderAPI from "~/services/apis/managerCenter/orderAPI";

const LayoutOrder = () => {
  const [listOrderPD, setListOrderPD] = useState([]);
  const [listOrderCF, setListOrderCF] = useState([]);
  const [listOrderDLING, setListOrderDLING] = useState([]);
  const [listOrderDLED, setListOrderDLED] = useState([]);
  const [listOrderCPL, setListOrderCPL] = useState([]);
  const [listOrderCC, setListOrderCC] = useState([]);
  const [isLoading, setIsLoading] = useState(false);

  useEffect(() => {
    setIsLoading(true);

    orderAPI.getOrder("PENDING")
      .then((dataRes) => {
        setListOrderPD(dataRes.data);
        setIsLoading(false);
      }).catch((error) => { });

    orderAPI.getOrder("CONFIRMED")
      .then((dataRes) => {
        setListOrderCF(dataRes.data);
        setIsLoading(false);
      }).catch((error) => { });

    orderAPI.getOrder("DELIVERING")
      .then((dataRes) => {
        setListOrderDLING(dataRes.data);
        setIsLoading(false);
      }).catch((error) => { });

    orderAPI.getOrder("DELIVERED")
      .then((dataRes) => {
        setListOrderDLED(dataRes.data);
        setIsLoading(false);
      }).catch((error) => { });

    orderAPI.getOrder("COMPLETED")
      .then((dataRes) => {
        setListOrderCPL(dataRes.data);
        setIsLoading(false);
      }).catch((error) => { });

    orderAPI.getOrder("CANCEL")
      .then((dataRes) => {
        setListOrderCC(dataRes.data);
        setIsLoading(false);
      }).catch((error) => { });
  }, []);

  return (
    <>
      {isLoading ? (
        <LoadingAdmin />
      ) : (
        <Order
          dataPD={listOrderPD}
          setListOrderPD={setListOrderPD}
          dataCF={listOrderCF}
          setListOrderCF={setListOrderCF}
          dataDLING={listOrderDLING}
          setListOrderDLING={setListOrderDLING}
          dataDLED={listOrderDLED}
          setListOrderDLED={setListOrderDLED}
          dataCPL={listOrderCPL}
          setListOrderCPL={setListOrderCPL}
          dataCC={listOrderCC}
          setListOrderCC={setListOrderCC}
        />
      )}
    </>
  );
};

export default LayoutOrder;
