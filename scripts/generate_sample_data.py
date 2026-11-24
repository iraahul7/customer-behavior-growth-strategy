import pandas as pd
import numpy as np

np.random.seed(42)
n_customers = 500
n_orders = 1500

customers = pd.DataFrame({
    "customer_id": range(1, n_customers + 1),
    "city": np.random.choice(["Delhi", "Mumbai", "Bengaluru", "Hyderabad", "Pune"], n_customers),
    "acquisition_channel": np.random.choice(["Organic", "Paid Search", "Social", "Referral"], n_customers),
    "signup_date": pd.date_range("2025-01-01", periods=n_customers, freq="12h").strftime("%Y-%m-%d")
})

orders = pd.DataFrame({
    "order_id": range(100001, 100001 + n_orders),
    "customer_id": np.random.randint(1, n_customers + 1, n_orders),
    "order_date": pd.date_range("2025-02-01", periods=n_orders, freq="4h").strftime("%Y-%m-%d"),
    "order_amount": np.round(np.random.lognormal(mean=7.1, sigma=0.6, size=n_orders), 2),
    "order_status": np.random.choice(["completed", "abandoned", "cancelled"], n_orders, p=[0.68, 0.24, 0.08])
})

customers.to_csv("data/sample_customers.csv", index=False)
orders.to_csv("data/sample_orders.csv", index=False)
