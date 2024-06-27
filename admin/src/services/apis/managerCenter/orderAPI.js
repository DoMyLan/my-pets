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
    getOrderStatusPayment: async (statusPayment, year) => {
        const response = await axios.get(`/order/payment/center?statusPayment=${statusPayment}&year=${year}`);
        return response.data;
    },
    getOrderStatusPaymentYM: async (statusPayment, year, month) => {
        console.log(statusPayment, year, month);
        const response = await axios.get(`/order/paymentYM/center?statusPayment=${statusPayment}&year=${year}&month=${month}`);
        return response.data;
    }


};

export default orderAPI;
