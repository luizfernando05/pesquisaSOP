import express from 'express';
import { AppDataSource } from './config/data-source';

const app = express();
const PORT = process.env.PORT || 3000;

app.use(express.json());

app.get('/', (req, res) => {
  res.send('SopAssist says hello!');
});

AppDataSource.initialize().then(() => {
  console.log('Database connected');

  app.listen(PORT, () => {
    console.log(`Server is running on http://localhost:${PORT}`);
  });
});
