import { get } from "react-hook-form";
import axios from "~/services/axios";

const petAPI = {
    getAllPets: async () => {
        const res = await axios.get(`/pet`);
        return res.data;
    },
    getPetById: async (id) => {
        const res = await axios.get(`/pet/one/${id}`);
        return res.data;
    },
    addPet: async (pet) => {
        const res = await axios.post(`/pet`, pet);
        return res.data;
    },
    updatePet: async (id, pet) => {
        const res = await axios.put(`/pet/${id}`, pet);
        return res.data;
    },
    deletePet: async (id) => {
        const res = await axios.delete(`/pet/${id}`);
        return res.data;
    }
}

export default petAPI;
