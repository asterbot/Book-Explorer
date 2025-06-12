import os
from dotenv import dotenv_values

DOT_ENV_PATH = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), ".env")
config = dotenv_values(DOT_ENV_PATH)

def get_env_config(name: str) -> str | None:
    if name in config:
        return config[name]
    else:
        # If the environment variable is not found
        return None
