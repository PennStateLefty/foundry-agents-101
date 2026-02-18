import React from "react";

interface LightbulbProps {
  isOn: boolean;
  color: string;
}

const Lightbulb: React.FC<LightbulbProps> = ({ isOn, color }) => {
  const dimColor = "#6b7280";
  const fillColor = isOn ? color : dimColor;

  return (
    <div
      style={{
        display: "inline-flex",
        justifyContent: "center",
        alignItems: "center",
        transition: "filter 0.6s ease",
        filter: isOn ? `drop-shadow(0 0 24px ${color})` : "none",
      }}
    >
      <svg
        xmlns="http://www.w3.org/2000/svg"
        viewBox="0 0 200 320"
        width="200"
        height="320"
      >
        <defs>
          {/* Glow filter */}
          <filter id="bulb-glow" x="-50%" y="-50%" width="200%" height="200%">
            <feGaussianBlur in="SourceGraphic" stdDeviation="10" result="blur" />
            <feMerge>
              <feMergeNode in="blur" />
              <feMergeNode in="SourceGraphic" />
            </feMerge>
          </filter>

          {/* Radial gradient for the glass */}
          <radialGradient id="glass-gradient" cx="50%" cy="40%" r="50%">
            <stop
              offset="0%"
              stopColor={isOn ? "#ffffff" : "#d1d5db"}
              stopOpacity={isOn ? 0.9 : 0.3}
            >
              {isOn && (
                <animate
                  attributeName="stop-opacity"
                  values="0.9;0.7;0.9"
                  dur="2s"
                  repeatCount="indefinite"
                />
              )}
            </stop>
            <stop offset="100%" stopColor={fillColor} stopOpacity={isOn ? 0.85 : 0.5} />
          </radialGradient>

          {/* Screw-base gradient */}
          <linearGradient id="base-gradient" x1="0" y1="0" x2="1" y2="1">
            <stop offset="0%" stopColor="#a8a29e" />
            <stop offset="50%" stopColor="#78716c" />
            <stop offset="100%" stopColor="#57534e" />
          </linearGradient>
        </defs>

        {/* Outer glow circle (visible when on) */}
        <circle
          cx="100"
          cy="110"
          r="90"
          fill={isOn ? color : "transparent"}
          opacity={isOn ? 0.15 : 0}
          style={{ transition: "opacity 0.6s ease, fill 0.6s ease" }}
        >
          {isOn && (
            <animate
              attributeName="r"
              values="85;95;85"
              dur="2.5s"
              repeatCount="indefinite"
            />
          )}
        </circle>

        {/* Glass bulb */}
        <path
          d={`
            M 70 190
            C 70 190, 40 160, 40 110
            C 40 65, 65 30, 100 30
            C 135 30, 160 65, 160 110
            C 160 160, 130 190, 130 190
            Z
          `}
          fill="url(#glass-gradient)"
          stroke={isOn ? color : "#9ca3af"}
          strokeWidth="2"
          filter={isOn ? "url(#bulb-glow)" : "none"}
          style={{
            transition: "stroke 0.6s ease",
          }}
        />

        {/* Filament lines */}
        <g
          stroke={isOn ? color : "#9ca3af"}
          strokeWidth="2"
          fill="none"
          opacity={isOn ? 0.7 : 0.25}
          style={{ transition: "opacity 0.6s ease, stroke 0.6s ease" }}
        >
          <path d="M 90 180 C 88 150, 82 130, 90 100 C 95 80, 100 75, 100 65" />
          <path d="M 110 180 C 112 150, 118 130, 110 100 C 105 80, 100 75, 100 65" />
        </g>

        {/* Neck / collar */}
        <rect
          x="72"
          y="190"
          width="56"
          height="14"
          rx="2"
          fill="#a8a29e"
          stroke="#78716c"
          strokeWidth="1"
        />

        {/* Screw base threads */}
        {[0, 1, 2, 3].map((i) => (
          <rect
            key={i}
            x={74 + i * 2}
            y={208 + i * 18}
            width={52 - i * 4}
            height="14"
            rx="3"
            fill="url(#base-gradient)"
            stroke="#57534e"
            strokeWidth="0.5"
          />
        ))}

        {/* Bottom contact */}
        <ellipse cx="100" cy="282" rx="14" ry="6" fill="#57534e" />
      </svg>

      <style>{`
        @keyframes pulse-glow {
          0%, 100% { opacity: 1; }
          50% { opacity: 0.85; }
        }
      `}</style>
    </div>
  );
};

export default Lightbulb;
