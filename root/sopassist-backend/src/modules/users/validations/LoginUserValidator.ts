import * as yup from 'yup';

export const LoginDoctorValidator = yup.object().shape({
  email: yup
    .string()
    .email('Formato de email inválido')
    .required('Email é obrigatório'),
  password: yup.string().required('Senha é obrigatório'),
});
