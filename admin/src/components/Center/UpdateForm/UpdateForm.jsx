import { useState, useEffect } from 'react';
import Button from '@mui/material/Button';
import Dialog from '@mui/material/Dialog';
import DialogActions from '@mui/material/DialogActions';
import DialogContent from '@mui/material/DialogContent';
import DialogTitle from '@mui/material/DialogTitle';

import { useForm } from 'react-hook-form';

import './UpdateForm.scss';

export default function UpdateForm(props) {
    const [open, setOpen] = useState(false);

    const {
        register,
        handleSubmit,
        setValue,
        formState: { errors }
    } = useForm();

    const handleClickOpen = () => {
        setOpen(true);
    };

    const handleClose = () => {
        setOpen(false);
    };

    useEffect(() => {
        for (let i = 0; i < props.fieldData.length; i++) {
            setValue(props.fieldData[i].nameRegister, props.data[props.fieldData[i].nameRegister]);
        }
        if (props.data?.category?.id !== undefined) {
            setValue('categoryId', props.data.category.id);
        }
    }, [setValue, props.data, props.fieldData]);

    const onSubmit = async (data) => {
        if (props.updateData) {
            props.updateData(data, props.data.id);
        }
    };

    return (
        <div>
            <img
                src="https://img.icons8.com/color/48/000000/edit--v1.png"
                alt="icon__update"
                className="icon__btn"
                onClick={handleClickOpen}
            />
            <Dialog
                open={open}
                onClose={handleClose}
                aria-labelledby="alert-dialog-title"
                aria-describedby="alert-dialog-description"
            >
                <DialogTitle id="alert-dialog-title" sx={{ paddingBottom: 0, fontSize: '18px', marginLeft: '10px' }}>
                    {'Cập nhật thông tin'}
                </DialogTitle>
                <form className="dialog__update" onSubmit={handleSubmit(onSubmit)}>
                    <DialogContent>
                        <div className="row">
                            {props.fieldData?.map((field, index) => (
                                <div className="col l-12 key-col" key={index}>
                                    <h2 className="title-field">{field.title}</h2>
                                    <input
                                        type="text"
                                        className="update-form__input"
                                        placeholder={field.placeholder}
                                        {...register(field.nameRegister, {
                                            required: field.nameRequire
                                        })}
                                    />
                                    {errors[field.nameRegister] && (
                                        <span className="message_error">{`${
                                            errors[field.nameRegister] && errors[field.nameRegister]?.message
                                        }`}</span>
                                    )}
                                </div>
                            ))}
                        </div>
                    </DialogContent>
                    <DialogActions>
                        <Button onClick={handleClose}>Cancel</Button>
                        <Button type="submit">Update</Button>
                    </DialogActions>
                </form>
            </Dialog>
        </div>
    );
}
