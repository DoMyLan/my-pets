import Box from '@mui/material/Box';
import LinearProgress from '@mui/material/LinearProgress';
import './LoadingCenter.scss';

export default function LoadingCenter() {
    return (
        <div className="loading-admin">
            <Box sx={{ width: '100%' }}>
                <LinearProgress />
            </Box>
        </div>
    );
}
