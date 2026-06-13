import { BoxRenderable, RGBA } from "@opentui/core"
import { createSignal, onCleanup, onMount, type JSX } from "solid-js"
import { useTheme } from "@tui/context/theme"
import { logo } from "@/cli/logo"

export function Logo(props: { ink?: RGBA } = {}) {
  const { theme } = useTheme()
  const [now, setNow] = createSignal(0)
  let box: BoxRenderable | undefined
  let timer: ReturnType<typeof setInterval> | undefined

  const stop = () => {
    if (!timer) return
    clearInterval(timer)
    timer = undefined
  }

  const tick = () => {
    setNow(performance.now())
  }

  onMount(() => {
    timer = setInterval(tick, 16)
  })

  onCleanup(stop)

  return (
    <box
      ref={(item: BoxRenderable) => (box = item)}
      width={49}
      height={5}
      flexGrow={0}
      flexShrink={0}
    >
      <text fg={props.ink ?? theme.text}>
        {logo.left.join("\n")}
      </text>
    </box>
  )
}

export function GoLogo() {
  const { theme } = useTheme()
  return <Logo ink={theme.text} />
}
