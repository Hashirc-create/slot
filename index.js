import express from 'express';
import cors from 'cors';
import dotenv from 'dotenv';
import { createClient } from '@supabase/supabase-js';

dotenv.config();

const app = express();
app.use(cors());
app.use(express.json());

const supabase = createClient(
  process.env.SUPABASE_URL,
  process.env.SUPABASE_ANON_KEY
);

app.get('/', (req, res) => {
  res.send('Seamless Slot Backend is running!');
});

// Get all slots
app.get('/slots', async (req, res) => {
  try {
    const { data, error } = await supabase
      .from('slots')
      .select('*')
      .order('start_time', { ascending: true });
    
    if (error) throw error;
    res.json(data);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Create a new slot
app.post('/slots', async (req, res) => {
  try {
    const { start_time, end_time, user_id } = req.body;
    const { data, error } = await supabase
      .from('slots')
      .insert([{ start_time, end_time, user_id }])
      .select();
    
    if (error) throw error;
    res.json(data[0]);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});