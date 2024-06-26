import { createSlice } from '@reduxjs/toolkit'

const userSlice = createSlice({
    name: 'user',
    initialState: {
        current: null,
        settings: false
    },
    reducers: {
        signup(state, action) {
        },
        signin(state, action) {
            localStorage.setItem('accessToken', action.payload.accessToken)
            localStorage.setItem('refreshToken', action.payload.refreshToken)
            // localStorage.setItem('user', JSON.stringify(action.payload.infoUserResponse))
            // state.accessToken = action.payload.accessToken
            // state.refreshToken = action.payload.refreshToken
            state.current= action.payload.infoUserResponse
        },
        setProfile(state, action) {
            localStorage.setItem('user', JSON.stringify(action.payload))
        },
        logout(state) {
            localStorage.removeItem('user')
            localStorage.removeItem('accessToken')
            localStorage.removeItem('refreshToken')
            state.current = null
        },
        editInfo(state, action) {
            state.current= action.payload
        },
        updateHost(state) {
            state.settings = true
        },
        refreshToken(state, action){
            localStorage.setItem('accessToken', action.payload.accessToken)
        }
    },
   
})

export default userSlice