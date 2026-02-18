import { useState, useEffect } from "react";

interface LightbulbState {
  isOn: boolean;
  color: string;
  loading: boolean;
  error: string | null;
}

export function useLightbulb(): LightbulbState {
  const [isOn, setIsOn] = useState<boolean>(false);
  const [color, setColor] = useState<string>("white");
  const [loading, setLoading] = useState<boolean>(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    let isMounted = true;

    const fetchState = async () => {
      try {
        const response = await fetch("/api/lightbulb");
        if (!response.ok) {
          throw new Error(`HTTP ${response.status}: ${response.statusText}`);
        }
        const data = await response.json();
        if (isMounted) {
          setIsOn(data.is_on);
          setColor(data.color);
          setError(null);
          setLoading(false);
        }
      } catch (err) {
        if (isMounted) {
          setError(err instanceof Error ? err.message : "Unknown error");
          setLoading(false);
        }
      }
    };

    fetchState();
    const interval = setInterval(fetchState, 2000);

    return () => {
      isMounted = false;
      clearInterval(interval);
    };
  }, []);

  return { isOn, color, loading, error };
}
