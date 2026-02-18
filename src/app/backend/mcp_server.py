from mcp.server.fastmcp import FastMCP
from lightbulb import lightbulb, Color

mcp = FastMCP("Lightbulb MCP Server", streamable_http_path="/")


@mcp.tool()
def get_light_state() -> dict:
    """Get the current state of the lightbulb, including whether it is on or off and its color."""
    return lightbulb.to_dict()


@mcp.tool()
def toggle_light() -> dict:
    """Toggle the lightbulb on or off. If it is currently on, it will turn off, and vice versa."""
    lightbulb.toggle()
    return lightbulb.to_dict()


@mcp.tool()
def set_color(color: str) -> dict:
    """Set the color of the lightbulb.

    Args:
        color: The color to set. Valid colors are: red, green, blue, yellow, white.
    """
    try:
        c = Color(color.lower())
    except ValueError:
        valid = [v.value for v in Color]
        return {"error": f"Invalid color '{color}'. Valid colors: {valid}"}
    lightbulb.set_color(c)
    return lightbulb.to_dict()
