defmodule AvaliacaoParaAprendizagemWeb.PageController do
  use AvaliacaoParaAprendizagemWeb, :controller

  @references %{
    "AMARAL, GUERRA" =>
      "AMARAL, Ana Luiza Neiva; GUERRA, Leonor Bezerra. **Neurociência e Educação: olhando para o futuro da aprendizagem**. Brasília: SESI/DN, 2022. Disponível em: https://static.portaldaindustria.com.br/media/filer_public/24/33/ 24331119-5631-42c0-b141-9821064c820c/neurociencia_e_educacao_2022.pdf. Acesso em 10, dez. 2023.",
    "CONSENZA, GUERRA" =>
      "COSENZA, Ramon; GUERRA, Leonor. **Neurociência e educação**. Artmed Editora, 2009.",
    "DEHAENE" =>
      "DEHAENE, Stanislas. **How we learn: Why brains learn better than any machine... for now**. Penguin, 2021.",
    "EDUCATION ENDOWMENT FOUNDATION" =>
      "EDUCATION ENDOWMENT FOUNDATION (EEF). **Evidence and Resources**, © 2024. Evidence-based resources to support teaching and learning for two-19-year-olds. Disponível em: https://educationendowmentfoundation.org.uk/education-evidence. Acesso em: 29 jan. 2024.",
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

    references = [
      @references["DEHAENE"]
    ]

    render(conn, :structure, page_title: page_title, references: references)
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

    references = [
      @references["CONSENZA, GUERRA"],
      @references["DEHAENE"],
      @references["EDUCATION ENDOWMENT FOUNDATION"]
    ]

    render(conn, :pillars, page_title: page_title, references: references)
  end

  def attention(conn, _params) do
    page_title = "Atenção"

    references = [
      @references["AMARAL, GUERRA"],
      @references["CONSENZA, GUERRA"],
      @references["DEHAENE"]
    ]

    render(conn, :attention, page_title: page_title, references: references)
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
