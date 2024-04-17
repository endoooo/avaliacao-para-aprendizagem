defmodule AvaliacaoParaAprendizagemWeb.PageController do
  use AvaliacaoParaAprendizagemWeb, :controller

  @references %{
    "DEHAENE" =>
      "DEHAENE, Stanislas. **How we learn: Why brains learn better than any machine... for now**. Penguin, 2021.",
    "FREIRE" =>
      "FREIRE, Paulo. **Professora, sim; tia, não: cartas a quem ousa ensinar**. Editora Paz e Terra, 2022."
  }

  # def home(conn, _params) do
  #   # The home page is often custom made,
  #   # so skip the default app layout.
  #   render(conn, :home, layout: false)
  # end

  def home(conn, _params) do
    references = [
      @references["FREIRE"]
    ]

    render(conn, :home, references: references)
  end

  def structure(conn, _params) do
    page_title = "Organização do projeto"
    render(conn, :structure, page_title: page_title)
  end

  def assessment_moments(conn, _params) do
    page_title = "Momentos avaliativos"
    render(conn, :assessment_moments, page_title: page_title)
  end

  def diagnostic_assessment(conn, _params) do
    page_title = "Avaliação diagnóstica"
    render(conn, :diagnostic_assessment, page_title: page_title)
  end

  def formative_assessment(conn, _params) do
    page_title = "Avaliação formativa"
    render(conn, :formative_assessment, page_title: page_title)
  end

  def summative_assessment(conn, _params) do
    page_title = "Avaliação somativa"
    render(conn, :summative_assessment, page_title: page_title)
  end

  def pillars(conn, _params) do
    page_title = "Pilares do aprendizado"
    render(conn, :pillars, page_title: page_title)
  end

  def attention(conn, _params) do
    page_title = "Atenção"
    render(conn, :attention, page_title: page_title)
  end

  def active_engagement(conn, _params) do
    page_title = "Envolvimento ativo"
    render(conn, :active_engagement, page_title: page_title)
  end

  def feedback(conn, _params) do
    page_title = "Feedback de erros"
    render(conn, :feedback, page_title: page_title)
  end

  def consolidation(conn, _params) do
    page_title = "Consolidação"
    render(conn, :consolidation, page_title: page_title)
  end

  def emotion(conn, _params) do
    page_title = "Emoção"
    render(conn, :emotion, page_title: page_title)
  end

  def metacognition(conn, _params) do
    page_title = "Metacognição"
    render(conn, :metacognition, page_title: page_title)
  end

  def practices(conn, _params) do
    page_title = "Práticas avaliativas"
    render(conn, :practices, page_title: page_title)
  end

  def principles(conn, _params) do
    page_title = "Princípios"
    render(conn, :principles, page_title: page_title)
  end

  def references(conn, _params) do
    page_title = "Referências"

    references =
      @references
      |> Enum.map(fn {_, reference} -> reference end)

    render(conn, :references, page_title: page_title, references: references)
  end

  def about(conn, _params) do
    page_title = "Sobre o projeto"
    render(conn, :about, page_title: page_title)
  end
end
