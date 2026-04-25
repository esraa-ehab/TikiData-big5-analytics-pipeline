"""
WebDriver factory — returns a configured undetected-chromedriver instance.
"""

import undetected_chromedriver as uc

def create_driver(version_main: int | None = None) -> uc.Chrome:
    options = uc.ChromeOptions()
    options.add_argument("--start-maximized")
 
    kwargs = {"options": options}
    if version_main is not None:
        kwargs["version_main"] = version_main
 
    return uc.Chrome(**kwargs)