"use client";

import * as AccordionPrimitive from "@radix-ui/react-accordion";

export function Accordion({
  children,
  ...props
}: React.ComponentPropsWithoutRef<typeof AccordionPrimitive.Root>) {
  return (
    <AccordionPrimitive.Root className="accordion" {...props}>
      {children}
    </AccordionPrimitive.Root>
  );
}

export function AccordionItem({
  children,
  ...props
}: React.ComponentPropsWithoutRef<typeof AccordionPrimitive.Item>) {
  return (
    <AccordionPrimitive.Item className="accordion-item" {...props}>
      {children}
    </AccordionPrimitive.Item>
  );
}

export function AccordionTrigger({
  children,
  ...props
}: React.ComponentPropsWithoutRef<typeof AccordionPrimitive.Trigger>) {
  return (
    <AccordionPrimitive.Header style={{ display: "flex" }}>
      <AccordionPrimitive.Trigger className="accordion-trigger" {...props}>
        {children}
        <ChevronDown />
      </AccordionPrimitive.Trigger>
    </AccordionPrimitive.Header>
  );
}

export function AccordionContent({
  children,
  ...props
}: React.ComponentPropsWithoutRef<typeof AccordionPrimitive.Content>) {
  return (
    <AccordionPrimitive.Content className="accordion-content" {...props}>
      <div className="accordion-content__inner">{children}</div>
    </AccordionPrimitive.Content>
  );
}

function ChevronDown() {
  return (
    <svg
      viewBox="0 0 24 24"
      fill="none"
      stroke="currentColor"
      strokeWidth="2"
      strokeLinecap="round"
      strokeLinejoin="round"
      className="accordion-trigger__icon"
      aria-hidden="true"
    >
      <path d="m6 9 6 6 6-6" />
    </svg>
  );
}
