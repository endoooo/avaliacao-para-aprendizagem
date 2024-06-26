defmodule AvaliacaoParaAprendizagemWeb.CoreComponents do
  @moduledoc """
  Provides core UI components.

  At first glance, this module may seem daunting, but its goal is to provide
  core building blocks for your application, such as modals, tables, and
  forms. The components consist mostly of markup and are well-documented
  with doc strings and declarative assigns. You may customize and style
  them in any way you want, based on your application growth and needs.

  The default components use Tailwind CSS, a utility-first CSS framework.
  See the [Tailwind CSS documentation](https://tailwindcss.com) to learn
  how to customize them or feel free to swap in another framework altogether.

  Icons are provided by [heroicons](https://heroicons.com). See `icon/1` for usage.
  """
  use Phoenix.Component
  import Phoenix.HTML, only: [raw: 1]

  alias Phoenix.LiveView.JS
  import AvaliacaoParaAprendizagemWeb.Gettext

  use Phoenix.VerifiedRoutes,
    endpoint: AvaliacaoParaAprendizagemWeb.Endpoint,
    router: AvaliacaoParaAprendizagemWeb.Router,
    statics: AvaliacaoParaAprendizagemWeb.static_paths()

  @doc """
  Renders a page header.
  """

  attr :title, :string, required: true
  attr :with_cover, :string, default: nil, doc: "cover image URL"

  slot :cover_img_credits

  def page_header(%{with_cover: nil} = assigns) do
    ~H"""
    <header class="p-10">
      <.menu_button />
      <.container>
        <h1 class="mt-10 heading-1 text-apa-primary">
          <%= @title %>
        </h1>
      </.container>
    </header>
    """
  end

  def page_header(assigns) do
    ~H"""
    <header
      class="relative flex flex-col items-start min-h-[calc(50vh)] p-10 bg-cover bg-center"
      style={"background-image: url('#{@with_cover}')"}
    >
      <div class="absolute inset-0 bg-white/80"></div>
      <.menu_button class="relative z-10" />
      <.container class="relative z-10 flex-1 flex flex-col justify-end">
        <h1 class="mt-10 heading-1 text-apa-primary">
          <%= @title %>
        </h1>
      </.container>
    </header>
    <div :if={@cover_img_credits != []} class="px-10 mt-2">
      <.container class="text-xs sm:text-right text-apa-subtle">
        <%= render_slot(@cover_img_credits) %>
      </.container>
    </div>
    """
  end

  @doc """
  Renders a menu button.
  """

  attr :theme, :string, default: "default"
  attr :class, :any, default: nil

  def menu_button(assigns) do
    ~H"""
    <button
      type="button"
      phx-click={show_menu()}
      class={[
        "flex items-center justify-center w-10 h-10 rounded-full",
        get_menu_button_theme_color(@theme),
        @class
      ]}
    >
      <.icon name="hero-bars-3" class="w-6 h-6" />
    </button>
    """
  end

  @menu_button_theme %{
    color: %{
      "default" => "text-apa-primary hover:bg-white",
      "white" => "text-white hover:bg-apa-primary"
    }
  }

  defp get_menu_button_theme_color(theme),
    do: Map.get(@menu_button_theme.color, theme)

  @doc """
  Renders the main menu.
  """

  attr :show, :boolean, default: false
  attr :conn, Plug.Conn, required: true

  def main_menu(assigns) do
    current_path =
      case assigns.conn.path_info do
        [path] -> path
        [] -> ""
      end

    assigns =
      assigns
      |> assign(:current_path, current_path)

    ~H"""
    <div
      class="hidden fixed inset-0 z-50 bg-apa-primary overflow-y-auto"
      id="menu"
      phx-mounted={@show && show_menu()}
      phx-remove={hide_menu()}
      data-cancel={JS.exec("phx-remove")}
    >
      <.focus_wrap
        id="menu-wrap"
        phx-window-keydown={JS.exec("data-cancel", to: "#menu")}
        phx-key="escape"
        class="p-10 text-white"
      >
        <button type="button" class="mb-10" phx-click={JS.exec("data-cancel", to: "#menu")}>
          <.icon name="hero-x-mark" class="w-6 h-6 text-white" />
        </button>
        <h5 class="heading-1 text-white">
          Avaliação para a aprendizagem & neurociência
        </h5>
        <nav>
          <ul class="flex flex-col gap-4 mt-10">
            <.main_menu_nav_li href={~p"/"} class={get_main_menu_active_class(@current_path, "")}>
              Introdução
            </.main_menu_nav_li>
            <.main_menu_nav_li
              href={~p"/organizacao"}
              class={get_main_menu_active_class(@current_path, "organizacao")}
            >
              Organização do projeto
            </.main_menu_nav_li>
          </ul>
          <h6 class="mt-10 font-display font-bold opacity-50">Sistematização</h6>
          <ul class="flex flex-col gap-4 mt-10">
            <.main_menu_nav_li
              href={~p"/momentos-avaliativos"}
              class={get_main_menu_active_class(@current_path, "momentos-avaliativos")}
            >
              Momentos avaliativos
              <:sub_items>
                <.main_menu_nav_ol_li
                  href={~p"/avaliacao-diagnostica"}
                  class={get_main_menu_active_class(@current_path, "avaliacao-diagnostica")}
                >
                  Avaliação diagnóstica 🚧
                </.main_menu_nav_ol_li>
                <.main_menu_nav_ol_li
                  href={~p"/avaliacao-formativa"}
                  class={get_main_menu_active_class(@current_path, "avaliacao-formativa")}
                >
                  Avaliação formativa 🚧
                </.main_menu_nav_ol_li>
                <.main_menu_nav_ol_li
                  href={~p"/avaliacao-somativa"}
                  class={get_main_menu_active_class(@current_path, "avaliacao-somativa")}
                >
                  Avaliação somativa 🚧
                </.main_menu_nav_ol_li>
              </:sub_items>
            </.main_menu_nav_li>
          </ul>
          <ul class="flex flex-col gap-4 mt-10">
            <.main_menu_nav_li
              href={~p"/pilares"}
              class={get_main_menu_active_class(@current_path, "pilares")}
            >
              Pilares do aprendizado
              <:sub_items>
                <.main_menu_nav_ol_li
                  href={~p"/atencao"}
                  class={get_main_menu_active_class(@current_path, "atencao")}
                >
                  Atenção 🚧
                </.main_menu_nav_ol_li>
                <.main_menu_nav_ol_li
                  href={~p"/envolvimento-ativo"}
                  class={get_main_menu_active_class(@current_path, "envolvimento-ativo")}
                >
                  Envolvimento ativo 🚧
                </.main_menu_nav_ol_li>
                <.main_menu_nav_ol_li
                  href={~p"/feedback-de-erros"}
                  class={get_main_menu_active_class(@current_path, "feedback-de-erros")}
                >
                  Feedback de erros 🚧
                </.main_menu_nav_ol_li>
                <.main_menu_nav_ol_li
                  href={~p"/consolidacao"}
                  class={get_main_menu_active_class(@current_path, "consolidacao")}
                >
                  Consolidação 🚧
                </.main_menu_nav_ol_li>
                <.main_menu_nav_ol_li
                  href={~p"/emocao"}
                  class={get_main_menu_active_class(@current_path, "emocao")}
                >
                  Emoção 🚧
                </.main_menu_nav_ol_li>
                <.main_menu_nav_ol_li
                  href={~p"/metacognicao"}
                  class={get_main_menu_active_class(@current_path, "metacognicao")}
                >
                  Metacognição 🚧
                </.main_menu_nav_ol_li>
              </:sub_items>
            </.main_menu_nav_li>
          </ul>
          <h6 class="mt-10 font-display font-bold opacity-50">Pílulas</h6>
          <ul class="flex flex-col gap-4 mt-10">
            <.main_menu_nav_li
              href={~p"/praticas-avaliativas"}
              class={get_main_menu_active_class(@current_path, "praticas-avaliativas")}
            >
              Práticas avaliativas 🚧
            </.main_menu_nav_li>
            <.main_menu_nav_li
              href={~p"/principios"}
              class={get_main_menu_active_class(@current_path, "principios")}
            >
              Princípios 🚧
            </.main_menu_nav_li>
          </ul>
          <h6 class="mt-10 font-display font-bold opacity-50">Outras páginas</h6>
          <ul class="flex flex-col gap-4 mt-10">
            <.main_menu_nav_li
              href={~p"/referencias"}
              class={get_main_menu_active_class(@current_path, "referencias")}
            >
              Referências
            </.main_menu_nav_li>
            <.main_menu_nav_li
              href={~p"/sobre"}
              class={get_main_menu_active_class(@current_path, "sobre")}
            >
              Sobre o projeto
            </.main_menu_nav_li>
          </ul>
          <div class="mt-10">
            <a
              href="/artigo-avaliacao-para-aprendizagem-e-neurociencia.pdf"
              target="_blank"
              class="inline-flex items-center gap-2 p-2 border border-white rounded-sm font-display hover:bg-white/10"
            >
              <.icon name="hero-document-text" class="w-6 h-6" /> Leia o artigo
            </a>
          </div>
        </nav>
      </.focus_wrap>
    </div>
    """
  end

  defp get_main_menu_active_class(current_path, link_path) when current_path == link_path,
    do: "font-bold"

  defp get_main_menu_active_class(_, _),
    do: "font-normal"

  def show_menu(js \\ %JS{}) do
    js
    |> JS.show(
      to: "#menu",
      transition:
        {"transition-all transform ease-out duration-300", "opacity-0 translate-y-10",
         "opacity-100 translate-y-0"}
    )
    |> JS.add_class("overflow-hidden", to: "body")
    |> JS.focus_first(to: "#menu")
  end

  def hide_menu(js \\ %JS{}) do
    js
    |> JS.hide(
      to: "#menu",
      transition:
        {"transition-all transform ease-in duration-200", "opacity-100 translate-y-0",
         "opacity-0 translate-y-10"}
    )
    |> JS.remove_class("overflow-hidden", to: "body")
    |> JS.pop_focus()
  end

  attr :href, :string, required: true
  attr :class, :any, default: nil
  slot :inner_block
  slot :sub_items

  defp main_menu_nav_li(assigns) do
    ~H"""
    <li class={["font-display text-base", @class]}>
      _ <a href={@href} class="underline hover:opacity-60"><%= render_slot(@inner_block) %></a>
      <ol :if={@sub_items != []} class="flex flex-col gap-4 pl-10 mt-4 list-decimal">
        <%= render_slot(@sub_items) %>
      </ol>
    </li>
    """
  end

  attr :href, :string, required: true
  attr :class, :any, default: nil
  slot :inner_block

  defp main_menu_nav_ol_li(assigns) do
    ~H"""
    <li class={["font-display text-base", @class]}>
      <a href={@href} class="underline hover:opacity-60"><%= render_slot(@inner_block) %></a>
    </li>
    """
  end

  @doc """
  Renders the site footer.
  """

  def footer(assigns) do
    ~H"""
    <footer class="p-10 bg-apa-primary">
      <.container>
        <.button theme="white" icon_left="hero-bars-3-mini" phx-click={show_menu()}>
          Menu de navegação
        </.button>
        <p class="body mt-6 text-white">
          O código fonte deste guia, de autoria de Eric Endo (2024), é aberto e <a
            href="https://github.com/endoooo/avaliacao-para-aprendizagem?tab=MIT-1-ov-file#readme"
            target="_blank"
            class="underline hover:opacity-60"
          >distribuído sob a licença MIT</a>.
        </p>
        <p class="notes mt-6 text-white">
          Projeto desenvolvido para o Trabalho de Conclusão de Curso da 4ª turma da pós-graduação “Neurociência na escola”, ministrada no <a
            href="https://institutosingularidades.edu.br/"
            target="_blank"
            class="underline hover:opacity-60"
          >Instituto Singularidades</a>.
        </p>
      </.container>
    </footer>
    """
  end

  @doc """
  Renders the page references block.
  """

  attr :references, :list, required: true, doc: "The list of page references"

  def page_references(assigns) do
    ~H"""
    <div :if={@references && @references != []} class="p-10 bg-apa-lighter">
      <.container>
        <h5 class="subtitle text-apa-dark">Referências nesta página</h5>
        <ul>
          <li :for={reference <- @references} class="mt-6 break-words prose">
            <%= raw(Earmark.as_html!(reference, inner_html: true)) %>
          </li>
        </ul>
        <.apa_link
          text="Veja todas as referências"
          href={~p"/referencias"}
          class="mt-6"
          theme="primary"
        />
      </.container>
    </div>
    """
  end

  @doc """
  Renders a container div.
  """

  attr :class, :any, default: nil
  slot :inner_block

  def container(assigns) do
    ~H"""
    <div class={["container mx-auto lg:max-w-2xl", @class]}>
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  @doc """
  Renders a pill card.
  """

  attr :type, :string, required: true
  attr :class, :any, default: nil
  slot :inner_block

  def pill_card(assigns) do
    ~H"""
    <div class={["p-6 sm:p-10 rounded-sm text-white bg-apa-primary shadow-lg", @class]}>
      <div class="inline-block p-2 mb-4 text-sm bg-white/25"><%= @type %></div>
      <p class="font-display text-base"><%= render_slot(@inner_block) %></p>
      <p class="mt-2 text-xs opacity-50">
        🚧 Pílulas em desenvolvimento. Em breve elas estarão funcionando :)
      </p>
      <div class="flex justify-end mt-6 sm:mt-10">
        <.icon name="hero-arrow-right" class="w-6 h-6" />
      </div>
    </div>
    """
  end

  @doc """
  Renders a link.
  """

  attr :text, :string, required: true
  attr :href, :string, required: true
  attr :target, :string, default: nil
  attr :theme, :string, default: "default"
  attr :class, :any, default: nil

  def apa_link(assigns) do
    ~H"""
    <a
      class={[
        "inline-flex items-baseline gap-1 hover:opacity-60",
        get_apa_link_theme_classes(@theme),
        @class
      ]}
      href={@href}
      target={@target}
    >
      <.icon name="hero-document-text-mini" class="w-5 h-5 translate-y-1" />
      <span class="underline"><%= @text %></span>
    </a>
    """
  end

  @apa_link %{
    "default" => "",
    "primary" => "text-apa-primary",
    "white" => "text-white"
  }

  defp get_apa_link_theme_classes(theme),
    do: Map.get(@apa_link, theme)

  @doc """
  Renders a modal.

  ## Examples

      <.modal id="confirm-modal">
        This is a modal.
      </.modal>

  JS commands may be passed to the `:on_cancel` to configure
  the closing/cancel event, for example:

      <.modal id="confirm" on_cancel={JS.navigate(~p"/posts")}>
        This is another modal.
      </.modal>

  """
  attr :id, :string, required: true
  attr :show, :boolean, default: false
  attr :on_cancel, JS, default: %JS{}
  slot :inner_block, required: true

  def modal(assigns) do
    ~H"""
    <div
      id={@id}
      phx-mounted={@show && show_modal(@id)}
      phx-remove={hide_modal(@id)}
      data-cancel={JS.exec(@on_cancel, "phx-remove")}
      class="relative z-50 hidden"
    >
      <div id={"#{@id}-bg"} class="bg-zinc-50/90 fixed inset-0 transition-opacity" aria-hidden="true" />
      <div
        class="fixed inset-0 overflow-y-auto"
        aria-labelledby={"#{@id}-title"}
        aria-describedby={"#{@id}-description"}
        role="dialog"
        aria-modal="true"
        tabindex="0"
      >
        <div class="flex min-h-full items-center justify-center">
          <div class="w-full max-w-3xl p-4 sm:p-6 lg:py-8">
            <.focus_wrap
              id={"#{@id}-container"}
              phx-window-keydown={JS.exec("data-cancel", to: "##{@id}")}
              phx-key="escape"
              phx-click-away={JS.exec("data-cancel", to: "##{@id}")}
              class="shadow-zinc-700/10 ring-zinc-700/10 relative hidden rounded-2xl bg-white p-14 shadow-lg ring-1 transition"
            >
              <div class="absolute top-6 right-5">
                <button
                  phx-click={JS.exec("data-cancel", to: "##{@id}")}
                  type="button"
                  class="-m-3 flex-none p-3 opacity-20 hover:opacity-40"
                  aria-label={gettext("close")}
                >
                  <.icon name="hero-x-mark-solid" class="h-5 w-5" />
                </button>
              </div>
              <div id={"#{@id}-content"}>
                <%= render_slot(@inner_block) %>
              </div>
            </.focus_wrap>
          </div>
        </div>
      </div>
    </div>
    """
  end

  @doc """
  Renders flash notices.

  ## Examples

      <.flash kind={:info} flash={@flash} />
      <.flash kind={:info} phx-mounted={show("#flash")}>Welcome Back!</.flash>
  """
  attr :id, :string, doc: "the optional id of flash container"
  attr :flash, :map, default: %{}, doc: "the map of flash messages to display"
  attr :title, :string, default: nil
  attr :kind, :atom, values: [:info, :error], doc: "used for styling and flash lookup"
  attr :rest, :global, doc: "the arbitrary HTML attributes to add to the flash container"

  slot :inner_block, doc: "the optional inner block that renders the flash message"

  def flash(assigns) do
    assigns = assign_new(assigns, :id, fn -> "flash-#{assigns.kind}" end)

    ~H"""
    <div
      :if={msg = render_slot(@inner_block) || Phoenix.Flash.get(@flash, @kind)}
      id={@id}
      phx-click={JS.push("lv:clear-flash", value: %{key: @kind}) |> hide("##{@id}")}
      role="alert"
      class={[
        "fixed top-2 right-2 mr-2 w-80 sm:w-96 z-50 rounded-lg p-3 ring-1",
        @kind == :info && "bg-emerald-50 text-emerald-800 ring-emerald-500 fill-cyan-900",
        @kind == :error && "bg-rose-50 text-rose-900 shadow-md ring-rose-500 fill-rose-900"
      ]}
      {@rest}
    >
      <p :if={@title} class="flex items-center gap-1.5 text-sm font-semibold leading-6">
        <.icon :if={@kind == :info} name="hero-information-circle-mini" class="h-4 w-4" />
        <.icon :if={@kind == :error} name="hero-exclamation-circle-mini" class="h-4 w-4" />
        <%= @title %>
      </p>
      <p class="mt-2 text-sm leading-5"><%= msg %></p>
      <button type="button" class="group absolute top-1 right-1 p-2" aria-label={gettext("close")}>
        <.icon name="hero-x-mark-solid" class="h-5 w-5 opacity-40 group-hover:opacity-70" />
      </button>
    </div>
    """
  end

  @doc """
  Shows the flash group with standard titles and content.

  ## Examples

      <.flash_group flash={@flash} />
  """
  attr :flash, :map, required: true, doc: "the map of flash messages"
  attr :id, :string, default: "flash-group", doc: "the optional id of flash container"

  def flash_group(assigns) do
    ~H"""
    <div id={@id}>
      <.flash kind={:info} title={gettext("Success!")} flash={@flash} />
      <.flash kind={:error} title={gettext("Error!")} flash={@flash} />
      <.flash
        id="client-error"
        kind={:error}
        title={gettext("We can't find the internet")}
        phx-disconnected={show(".phx-client-error #client-error")}
        phx-connected={hide("#client-error")}
        hidden
      >
        <%= gettext("Attempting to reconnect") %>
        <.icon name="hero-arrow-path" class="ml-1 h-3 w-3 animate-spin" />
      </.flash>

      <.flash
        id="server-error"
        kind={:error}
        title={gettext("Something went wrong!")}
        phx-disconnected={show(".phx-server-error #server-error")}
        phx-connected={hide("#server-error")}
        hidden
      >
        <%= gettext("Hang in there while we get back on track") %>
        <.icon name="hero-arrow-path" class="ml-1 h-3 w-3 animate-spin" />
      </.flash>
    </div>
    """
  end

  @doc """
  Renders a simple form.

  ## Examples

      <.simple_form for={@form} phx-change="validate" phx-submit="save">
        <.input field={@form[:email]} label="Email"/>
        <.input field={@form[:username]} label="Username" />
        <:actions>
          <.button>Save</.button>
        </:actions>
      </.simple_form>
  """
  attr :for, :any, required: true, doc: "the datastructure for the form"
  attr :as, :any, default: nil, doc: "the server side parameter to collect all input under"

  attr :rest, :global,
    include: ~w(autocomplete name rel action enctype method novalidate target multipart),
    doc: "the arbitrary HTML attributes to apply to the form tag"

  slot :inner_block, required: true
  slot :actions, doc: "the slot for form actions, such as a submit button"

  def simple_form(assigns) do
    ~H"""
    <.form :let={f} for={@for} as={@as} {@rest}>
      <div class="mt-10 space-y-8 bg-white">
        <%= render_slot(@inner_block, f) %>
        <div :for={action <- @actions} class="mt-2 flex items-center justify-between gap-6">
          <%= render_slot(action, f) %>
        </div>
      </div>
    </.form>
    """
  end

  @doc """
  Renders a button.

  ## Examples

      <.button>Send!</.button>
      <.button phx-click="go" class="ml-2">Send!</.button>
  """
  attr :theme, :string, default: "primary"
  attr :type, :string, default: "button"
  attr :icon_left, :string, default: nil
  attr :icon_right, :string, default: nil
  attr :class, :string, default: nil
  attr :rest, :global, include: ~w(disabled form name value)

  slot :inner_block, required: true

  def button(assigns) do
    ~H"""
    <button
      type={@type}
      class={[
        "inline-flex items-center gap-2 max-w-full px-4 py-2 rounded-full border font-display text-base",
        "phx-submit-loading:opacity-75 active:text-white/80",
        get_button_theme_classes(@theme),
        @class
      ]}
      {@rest}
    >
      <.icon :if={@icon_left} name={@icon_left} class="w-5 h-5" />
      <div class="flex-1 truncate"><%= render_slot(@inner_block) %></div>
      <.icon :if={@icon_right} name={@icon_right} class="w-5 h-5" />
    </button>
    """
  end

  @button_themes %{
    "primary" => "border-apa-primary text-apa-primary hover:bg-apa-primary/10",
    "white" => "border-white text-white hover:bg-white/10"
  }

  defp get_button_theme_classes(theme), do: @button_themes[theme]

  @doc """
  Renders an input with label and error messages.

  A `Phoenix.HTML.FormField` may be passed as argument,
  which is used to retrieve the input name, id, and values.
  Otherwise all attributes may be passed explicitly.

  ## Types

  This function accepts all HTML input types, considering that:

    * You may also set `type="select"` to render a `<select>` tag

    * `type="checkbox"` is used exclusively to render boolean values

    * For live file uploads, see `Phoenix.Component.live_file_input/1`

  See https://developer.mozilla.org/en-US/docs/Web/HTML/Element/input
  for more information.

  ## Examples

      <.input field={@form[:email]} type="email" />
      <.input name="my-input" errors={["oh no!"]} />
  """
  attr :id, :any, default: nil
  attr :name, :any
  attr :label, :string, default: nil
  attr :value, :any

  attr :type, :string,
    default: "text",
    values: ~w(checkbox color date datetime-local email file hidden month number password
               range radio search select tel text textarea time url week)

  attr :field, Phoenix.HTML.FormField,
    doc: "a form field struct retrieved from the form, for example: @form[:email]"

  attr :errors, :list, default: []
  attr :checked, :boolean, doc: "the checked flag for checkbox inputs"
  attr :prompt, :string, default: nil, doc: "the prompt for select inputs"
  attr :options, :list, doc: "the options to pass to Phoenix.HTML.Form.options_for_select/2"
  attr :multiple, :boolean, default: false, doc: "the multiple flag for select inputs"

  attr :rest, :global,
    include: ~w(accept autocomplete capture cols disabled form list max maxlength min minlength
                multiple pattern placeholder readonly required rows size step)

  slot :inner_block

  def input(%{field: %Phoenix.HTML.FormField{} = field} = assigns) do
    assigns
    |> assign(field: nil, id: assigns.id || field.id)
    |> assign(:errors, Enum.map(field.errors, &translate_error(&1)))
    |> assign_new(:name, fn -> if assigns.multiple, do: field.name <> "[]", else: field.name end)
    |> assign_new(:value, fn -> field.value end)
    |> input()
  end

  def input(%{type: "checkbox"} = assigns) do
    assigns =
      assign_new(assigns, :checked, fn ->
        Phoenix.HTML.Form.normalize_value("checkbox", assigns[:value])
      end)

    ~H"""
    <div phx-feedback-for={@name}>
      <label class="flex items-center gap-4 text-sm leading-6 text-zinc-600">
        <input type="hidden" name={@name} value="false" />
        <input
          type="checkbox"
          id={@id}
          name={@name}
          value="true"
          checked={@checked}
          class="rounded border-zinc-300 text-zinc-900 focus:ring-0"
          {@rest}
        />
        <%= @label %>
      </label>
      <.error :for={msg <- @errors}><%= msg %></.error>
    </div>
    """
  end

  def input(%{type: "select"} = assigns) do
    ~H"""
    <div phx-feedback-for={@name}>
      <.label for={@id}><%= @label %></.label>
      <select
        id={@id}
        name={@name}
        class="mt-2 block w-full rounded-md border border-gray-300 bg-white shadow-sm focus:border-zinc-400 focus:ring-0 sm:text-sm"
        multiple={@multiple}
        {@rest}
      >
        <option :if={@prompt} value=""><%= @prompt %></option>
        <%= Phoenix.HTML.Form.options_for_select(@options, @value) %>
      </select>
      <.error :for={msg <- @errors}><%= msg %></.error>
    </div>
    """
  end

  def input(%{type: "textarea"} = assigns) do
    ~H"""
    <div phx-feedback-for={@name}>
      <.label for={@id}><%= @label %></.label>
      <textarea
        id={@id}
        name={@name}
        class={[
          "mt-2 block w-full rounded-lg text-zinc-900 focus:ring-0 sm:text-sm sm:leading-6",
          "min-h-[6rem] phx-no-feedback:border-zinc-300 phx-no-feedback:focus:border-zinc-400",
          @errors == [] && "border-zinc-300 focus:border-zinc-400",
          @errors != [] && "border-rose-400 focus:border-rose-400"
        ]}
        {@rest}
      ><%= Phoenix.HTML.Form.normalize_value("textarea", @value) %></textarea>
      <.error :for={msg <- @errors}><%= msg %></.error>
    </div>
    """
  end

  # All other inputs text, datetime-local, url, password, etc. are handled here...
  def input(assigns) do
    ~H"""
    <div phx-feedback-for={@name}>
      <.label for={@id}><%= @label %></.label>
      <input
        type={@type}
        name={@name}
        id={@id}
        value={Phoenix.HTML.Form.normalize_value(@type, @value)}
        class={[
          "mt-2 block w-full rounded-lg text-zinc-900 focus:ring-0 sm:text-sm sm:leading-6",
          "phx-no-feedback:border-zinc-300 phx-no-feedback:focus:border-zinc-400",
          @errors == [] && "border-zinc-300 focus:border-zinc-400",
          @errors != [] && "border-rose-400 focus:border-rose-400"
        ]}
        {@rest}
      />
      <.error :for={msg <- @errors}><%= msg %></.error>
    </div>
    """
  end

  @doc """
  Renders a label.
  """
  attr :for, :string, default: nil
  slot :inner_block, required: true

  def label(assigns) do
    ~H"""
    <label for={@for} class="block text-sm font-semibold leading-6 text-zinc-800">
      <%= render_slot(@inner_block) %>
    </label>
    """
  end

  @doc """
  Generates a generic error message.
  """
  slot :inner_block, required: true

  def error(assigns) do
    ~H"""
    <p class="mt-3 flex gap-3 text-sm leading-6 text-rose-600 phx-no-feedback:hidden">
      <.icon name="hero-exclamation-circle-mini" class="mt-0.5 h-5 w-5 flex-none" />
      <%= render_slot(@inner_block) %>
    </p>
    """
  end

  @doc """
  Renders a header with title.
  """
  attr :class, :string, default: nil

  slot :inner_block, required: true
  slot :subtitle
  slot :actions

  def header(assigns) do
    ~H"""
    <header class={[@actions != [] && "flex items-center justify-between gap-6", @class]}>
      <div>
        <h1 class="text-lg font-semibold leading-8 text-zinc-800">
          <%= render_slot(@inner_block) %>
        </h1>
        <p :if={@subtitle != []} class="mt-2 text-sm leading-6 text-zinc-600">
          <%= render_slot(@subtitle) %>
        </p>
      </div>
      <div class="flex-none"><%= render_slot(@actions) %></div>
    </header>
    """
  end

  @doc ~S"""
  Renders a table with generic styling.

  ## Examples

      <.table id="users" rows={@users}>
        <:col :let={user} label="id"><%= user.id %></:col>
        <:col :let={user} label="username"><%= user.username %></:col>
      </.table>
  """
  attr :id, :string, required: true
  attr :rows, :list, required: true
  attr :row_id, :any, default: nil, doc: "the function for generating the row id"
  attr :row_click, :any, default: nil, doc: "the function for handling phx-click on each row"

  attr :row_item, :any,
    default: &Function.identity/1,
    doc: "the function for mapping each row before calling the :col and :action slots"

  slot :col, required: true do
    attr :label, :string
  end

  slot :action, doc: "the slot for showing user actions in the last table column"

  def table(assigns) do
    assigns =
      with %{rows: %Phoenix.LiveView.LiveStream{}} <- assigns do
        assign(assigns, row_id: assigns.row_id || fn {id, _item} -> id end)
      end

    ~H"""
    <div class="overflow-y-auto px-4 sm:overflow-visible sm:px-0">
      <table class="w-[40rem] mt-11 sm:w-full">
        <thead class="text-sm text-left leading-6 text-zinc-500">
          <tr>
            <th :for={col <- @col} class="p-0 pb-4 pr-6 font-normal"><%= col[:label] %></th>
            <th :if={@action != []} class="relative p-0 pb-4">
              <span class="sr-only"><%= gettext("Actions") %></span>
            </th>
          </tr>
        </thead>
        <tbody
          id={@id}
          phx-update={match?(%Phoenix.LiveView.LiveStream{}, @rows) && "stream"}
          class="relative divide-y divide-zinc-100 border-t border-zinc-200 text-sm leading-6 text-zinc-700"
        >
          <tr :for={row <- @rows} id={@row_id && @row_id.(row)} class="group hover:bg-zinc-50">
            <td
              :for={{col, i} <- Enum.with_index(@col)}
              phx-click={@row_click && @row_click.(row)}
              class={["relative p-0", @row_click && "hover:cursor-pointer"]}
            >
              <div class="block py-4 pr-6">
                <span class="absolute -inset-y-px right-0 -left-4 group-hover:bg-zinc-50 sm:rounded-l-xl" />
                <span class={["relative", i == 0 && "font-semibold text-zinc-900"]}>
                  <%= render_slot(col, @row_item.(row)) %>
                </span>
              </div>
            </td>
            <td :if={@action != []} class="relative w-14 p-0">
              <div class="relative whitespace-nowrap py-4 text-right text-sm font-medium">
                <span class="absolute -inset-y-px -right-4 left-0 group-hover:bg-zinc-50 sm:rounded-r-xl" />
                <span
                  :for={action <- @action}
                  class="relative ml-4 font-semibold leading-6 text-zinc-900 hover:text-zinc-700"
                >
                  <%= render_slot(action, @row_item.(row)) %>
                </span>
              </div>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
    """
  end

  @doc """
  Renders a data list.

  ## Examples

      <.list>
        <:item title="Title"><%= @post.title %></:item>
        <:item title="Views"><%= @post.views %></:item>
      </.list>
  """
  slot :item, required: true do
    attr :title, :string, required: true
  end

  def list(assigns) do
    ~H"""
    <div class="mt-14">
      <dl class="-my-4 divide-y divide-zinc-100">
        <div :for={item <- @item} class="flex gap-4 py-4 text-sm leading-6 sm:gap-8">
          <dt class="w-1/4 flex-none text-zinc-500"><%= item.title %></dt>
          <dd class="text-zinc-700"><%= render_slot(item) %></dd>
        </div>
      </dl>
    </div>
    """
  end

  @doc """
  Renders a back navigation link.

  ## Examples

      <.back navigate={~p"/posts"}>Back to posts</.back>
  """
  attr :navigate, :any, required: true
  slot :inner_block, required: true

  def back(assigns) do
    ~H"""
    <div class="mt-16">
      <.link
        navigate={@navigate}
        class="text-sm font-semibold leading-6 text-zinc-900 hover:text-zinc-700"
      >
        <.icon name="hero-arrow-left-solid" class="h-3 w-3" />
        <%= render_slot(@inner_block) %>
      </.link>
    </div>
    """
  end

  @doc """
  Renders a [Heroicon](https://heroicons.com).

  Heroicons come in three styles – outline, solid, and mini.
  By default, the outline style is used, but solid and mini may
  be applied by using the `-solid` and `-mini` suffix.

  You can customize the size and colors of the icons by setting
  width, height, and background color classes.

  Icons are extracted from the `deps/heroicons` directory and bundled within
  your compiled app.css by the plugin in your `assets/tailwind.config.js`.

  ## Examples

      <.icon name="hero-x-mark-solid" />
      <.icon name="hero-arrow-path" class="ml-1 w-3 h-3 animate-spin" />
  """
  attr :name, :string, required: true
  attr :class, :string, default: nil

  def icon(%{name: "hero-" <> _} = assigns) do
    ~H"""
    <span class={[@name, @class]} />
    """
  end

  ## JS Commands

  def show(js \\ %JS{}, selector) do
    JS.show(js,
      to: selector,
      transition:
        {"transition-all transform ease-out duration-300",
         "opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95",
         "opacity-100 translate-y-0 sm:scale-100"}
    )
  end

  def hide(js \\ %JS{}, selector) do
    JS.hide(js,
      to: selector,
      time: 200,
      transition:
        {"transition-all transform ease-in duration-200",
         "opacity-100 translate-y-0 sm:scale-100",
         "opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95"}
    )
  end

  def show_modal(js \\ %JS{}, id) when is_binary(id) do
    js
    |> JS.show(to: "##{id}")
    |> JS.show(
      to: "##{id}-bg",
      transition: {"transition-all transform ease-out duration-300", "opacity-0", "opacity-100"}
    )
    |> show("##{id}-container")
    |> JS.add_class("overflow-hidden", to: "body")
    |> JS.focus_first(to: "##{id}-content")
  end

  def hide_modal(js \\ %JS{}, id) do
    js
    |> JS.hide(
      to: "##{id}-bg",
      transition: {"transition-all transform ease-in duration-200", "opacity-100", "opacity-0"}
    )
    |> hide("##{id}-container")
    |> JS.hide(to: "##{id}", transition: {"block", "block", "hidden"})
    |> JS.remove_class("overflow-hidden", to: "body")
    |> JS.pop_focus()
  end

  @doc """
  Translates an error message using gettext.
  """
  def translate_error({msg, opts}) do
    # When using gettext, we typically pass the strings we want
    # to translate as a static argument:
    #
    #     # Translate the number of files with plural rules
    #     dngettext("errors", "1 file", "%{count} files", count)
    #
    # However the error messages in our forms and APIs are generated
    # dynamically, so we need to translate them by calling Gettext
    # with our gettext backend as first argument. Translations are
    # available in the errors.po file (as we use the "errors" domain).
    if count = opts[:count] do
      Gettext.dngettext(AvaliacaoParaAprendizagemWeb.Gettext, "errors", msg, msg, count, opts)
    else
      Gettext.dgettext(AvaliacaoParaAprendizagemWeb.Gettext, "errors", msg, opts)
    end
  end

  @doc """
  Translates the errors for a field from a keyword list of errors.
  """
  def translate_errors(errors, field) when is_list(errors) do
    for {^field, {msg, opts}} <- errors, do: translate_error({msg, opts})
  end
end
