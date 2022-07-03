#define OLC_PGE_APPLICATION
#include "olcPixelGameEngine.h"

class Example : public olc::PixelGameEngine
{
public:
	Example()
	{
		sAppName = "Example";
	}

public:
	bool OnUserCreate() override
	{
		// Called once at the start, so create things here
		return true;
	}

	bool bCursorToggle = true;

	bool OnUserUpdate(float fElapsedTime) override
	{
		
		// Toggle System Mouse Cursor
		if(GetKey(olc::SPACE).bPressed)
		{
			bCursorToggle = !bCursorToggle;
			ShowSystemCursor(bCursorToggle);
			std::cout << "Toggle\n";
		}
		
		Clear(olc::BLACK);
		FillCircle(GetMousePos(), 5, olc::RED);
		DrawCircle(GetMousePos(), 5, olc::GREY);
		
		return !GetKey(olc::ESCAPE).bPressed;
	}
};

int main()
{
	Example demo;
	if (demo.Construct(256, 240, 4, 4))
		demo.Start();

	return 0;
}
