import { useState, useEffect, useContext } from "react";

import Pets from "~/pages/center/LayoutPets/Pets";
import Loading from "~/components/Center/LoadingCenter/LoadingCenter";
import petAPI from "~/services/apis/petAPI/petAPI";

const LayoutPets = () => {
  const [listPet, setListPet] = useState([]);
  const [isLoading, setIsLoading] = useState(false);

  useEffect(() => {
    setIsLoading(true);

    petAPI.getAllPets().then((dataRes) => {
      setListPet(dataRes.data);
      setIsLoading(false);
    })
      .catch((error) => { });
  }, []);

  return (
    <>
      {isLoading ? (
        <Loading />
      ) : (
        <Pets data={listPet} setListPet={setListPet} />
      )}
    </>
  );
};

export default LayoutPets;
