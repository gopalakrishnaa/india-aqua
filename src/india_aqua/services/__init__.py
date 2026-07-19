from importlib import import_module

__all__ = [
    "create_client",
    "generate_api_key",
    "get_client_by_api_key",
    "hash_api_key",
    "list_stations",
    "get_latest_readings",
    "get_readings_history",
    "get_deficiency_report",
    "run_scrape_pipeline",
    "run_seed",
    "import_ganga_workbooks",
    "analyze_ganga_data",
]


def __getattr__(name: str):
    module_attr_map = {
        "create_client": ("india_aqua.services.auth", "create_client"),
        "generate_api_key": ("india_aqua.services.auth", "generate_api_key"),
        "get_client_by_api_key": ("india_aqua.services.auth", "get_client_by_api_key"),
        "hash_api_key": ("india_aqua.services.auth", "hash_api_key"),
        "list_stations": ("india_aqua.services.readings", "list_stations"),
        "get_latest_readings": ("india_aqua.services.readings", "get_latest_readings"),
        "get_readings_history": ("india_aqua.services.readings", "get_readings_history"),
        "get_deficiency_report": ("india_aqua.services.readings", "get_deficiency_report"),
        "run_scrape_pipeline": ("india_aqua.services.scrape_pipeline", "run_scrape_pipeline"),
        "run_seed": ("india_aqua.services.seed", "run_seed"),
        "import_ganga_workbooks": ("india_aqua.services.ganga_import", "import_ganga_workbooks"),
        "analyze_ganga_data": ("india_aqua.services.ganga_analysis", "analyze_ganga_data"),
    }
    if name not in module_attr_map:
        raise AttributeError(name)
    module_name, attr_name = module_attr_map[name]
    module = import_module(module_name)
    return getattr(module, attr_name)
