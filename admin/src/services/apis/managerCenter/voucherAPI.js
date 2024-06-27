import axios from '~/services/axios';
const voucherAPI = {
    getVoucher: async (status) => {
        const user = JSON.parse(localStorage.getItem('user'));
        const response = await axios.get(`/voucher/${user._id}?use=${status}`);
        return response.data;
    },
    createVoucher: async (data) => {
        const response = await axios.post('/voucher', data);
        return response.data;
    },
    delete: async (id) => {
        const response = await axios.delete(`/voucher/${id}`);
        return response.data;
    },
    update: async (id, data) => {
        const response = await axios.put(`/voucher/${id}`, data);
        return response.data;
    }
};

export default voucherAPI;
