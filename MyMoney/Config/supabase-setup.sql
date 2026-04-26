-- Supabase Setup for MyMoney Budget Persistence
-- Run this in Supabase Dashboard → SQL Editor

CREATE TABLE budgets (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  monthly_income DECIMAL DEFAULT 0
);

CREATE TABLE budget_expenses (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  budget_id UUID REFERENCES budgets(id) ON DELETE CASCADE NOT NULL,
  name TEXT NOT NULL,
  amount DECIMAL NOT NULL,
  category TEXT NOT NULL
);

ALTER TABLE budgets ENABLE ROW LEVEL SECURITY;
ALTER TABLE budget_expenses ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can CRUD own budgets" ON budgets
  FOR ALL USING (auth.uid() = user_id);

CREATE POLICY "Users can CRUD own expenses" ON budget_expenses
  FOR ALL USING (budget_id IN (SELECT id FROM budgets WHERE user_id = auth.uid()));
