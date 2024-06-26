import axios from '~/services/axios';
const orderAPI = {
    getOrder: async (statusOrder) => {
        const response = await axios.get(`/order/seller?statusOrder=${statusOrder}`);
        return response.data;
    },
    updateOrder: async (id, data) => {
        const response = await axios.put(`/order/${id}`, data);
        return response.data;
    },

};

export default orderAPI;
