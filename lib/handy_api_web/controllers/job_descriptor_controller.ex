defmodule HandyApiWeb.JobDescriptorController do
  use HandyApiWeb, :controller
  alias HandyApi.Logging.JobDescriptor

  action_fallback(HandyApiWeb.FallbackController)

  def get_descriptors(conn, %{"source_id" => source_id} = params) do
    case JobDescriptorService.get_job_descriptors(source_id) do
      {:ok, descriptors} -> render(conn, "index.json", job_descriptors: descriptors)
      {:error} -> render(conn, HandyApiWeb.ErrorView, :"400")
    end
  end

  def edit(conn, %{
        "id" => id,
        "name" => name,
        "frequency" => frequency,
        "tolerance" => tolerance
      }) do
    req = %{id: id, name: name, frequency: frequency, tolerance: tolerance}

    case JobDescriptorService.modify_job_descriptor(req) do
      {:ok, job} -> render(conn, "show.json", job_descriptor: job)
      {:error, _msg} -> render(conn, HandyApiWeb.ErrorView, :"400")
    end
  end

  def insert(
        conn,
        %{
          "source_id" => source_id,
          "name" => name,
          "frequency" => frequency,
          "tolerance" => tolerance
        }
      ) do
    req = %{source_id: source_id, name: name, frequency: frequency, tolerance: tolerance}

    case JobDescriptorService.create_job_descriptor(req) do
      {:ok, descriptor} -> render(conn, "show.json", job_descriptor: descriptor)
      {:error} -> render(conn, HandyApiWeb.ErrorView, :"400")
    end
  end
end
