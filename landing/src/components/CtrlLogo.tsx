export function CtrlLogo({ className = "" }: { className?: string }) {
  return (
    <span
      className={`inline-flex items-center gap-1.5 font-semibold tracking-tight ${className}`}
      aria-label="CTRL"
    >
      <span
        aria-hidden="true"
        className="grid h-7 w-7 place-items-center rounded-md bg-primary text-primary-foreground text-[11px] font-bold"
      >
        ⌃
      </span>
      <span className="text-base">CTRL</span>
    </span>
  );
}