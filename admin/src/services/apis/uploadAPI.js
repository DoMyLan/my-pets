import axios from "~/services/axios";

const uploadAPI = {
    uploadMulti: async (files) => {
        const formData = new FormData();
        for(var i=0; i<files.length; i++){
            formData.append(`file`, files[i]);
        }

        try {
            const res = await axios.post("/upload/multi-image", formData, {
                headers: {
                    'Content-Type': 'multipart/form-data'
                }
            });
            return res.data.images;
        } catch (error) {
            throw error;
        }
    }
}

export default uploadAPI;
