import asyncio
from plantid.invasive import InvasiveChecker

async def main():
    checker = InvasiveChecker()
    
    # Test case 1: Water Hyacinth in Spain (Should be invasive)
    print("Testing: Water Hyacinth (凤眼蓝) in Spain")
    result1 = await checker.check_invasive("凤眼蓝", "Spain")
    print(f"Result: {result1}")
    
    # Test case 2: Water Hyacinth in China (Should NOT be invasive, per user prompt example)
    print("\nTesting: Water Hyacinth (凤眼蓝) in China")
    result2 = await checker.check_invasive("凤眼蓝", "China")
    print(f"Result: {result2}")

if __name__ == "__main__":
    asyncio.run(main())
