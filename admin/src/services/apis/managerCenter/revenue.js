import axios from '~/services/axios';
const revenueAPI = {
    getRevenueYear: async (y) => {
        const response = await axios.get(`/statistical/year?y=${y}`);
        return response.data;
    },
    getRevenueYearMonth: async (y, m) => {
        const response = await axios.get(`/statistical/year/month?y=${y}&m=${m}`);
        return response.data;
    }
};

export default revenueAPI;
