/*
  # Initial Schema Setup
  
  1. New Tables
    - `slots` table for managing time slots
      - `id` (uuid, primary key)
      - `start_time` (timestamptz)
      - `end_time` (timestamptz)
      - `is_booked` (boolean)
      - `user_id` (uuid, references auth.users)
      - `created_at` (timestamptz)
  
  2. Security
    - Enable RLS on slots table
    - Add policies for authenticated users to:
      - Read all slots
      - Create and update their own slots
*/

CREATE TABLE IF NOT EXISTS slots (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  start_time timestamptz NOT NULL,
  end_time timestamptz NOT NULL,
  is_booked boolean DEFAULT false,
  user_id uuid REFERENCES auth.users,
  created_at timestamptz DEFAULT now()
);

ALTER TABLE slots ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can view slots"
  ON slots
  FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Users can create slots"
  ON slots
  FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own slots"
  ON slots
  FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);