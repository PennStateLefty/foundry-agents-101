from dataclasses import dataclass, field
from enum import Enum


class Color(str, Enum):
    RED = "red"
    GREEN = "green"
    BLUE = "blue"
    YELLOW = "yellow"
    WHITE = "white"


@dataclass
class LightbulbState:
    is_on: bool = False
    color: Color = Color.WHITE

    def toggle(self) -> None:
        self.is_on = not self.is_on

    def set_color(self, color: Color) -> None:
        self.color = color

    def to_dict(self) -> dict:
        return {
            "is_on": self.is_on,
            "color": self.color.value,
        }


# Singleton in-memory state
lightbulb = LightbulbState()
