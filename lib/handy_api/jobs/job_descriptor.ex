defmodule JobDescriptor do
  defstruct [:id, :source_id, :name, :tolerance, :frequency, :expected_at]
end

defmodule JobDescriptorService do
  alias HandyApi.Api
  use Cartograf

  map(Proto.JobDescriptor, JobDescriptor, :proto_to_descriptor, auto: true) do
  end

  def get_job_descriptors(source_id) do
    Api.call(fn channel ->
      case Proto.SourceJob.Stub.get_jobs(channel, %Proto.IdQuery{id: source_id}) do
        {:ok, stream} -> {:ok, Enum.map(stream, fn {:ok, e} -> proto_to_descriptor(e) end)}
        {:error, error} -> {:error, error}
      end
    end)
  end

  def modify_job_descriptor(job) do
    Api.call(fn channel ->
      req = Proto.JobDescriptor.new(job)

      case Proto.SourceJob.Stub.modify_job_descriptor(channel, req) do
        {:ok, desc} -> {:ok, proto_to_descriptor(desc)}
        {:error, msg} -> {:error, msg}
      end
    end)
  end

  def create_job_descriptor(newJob) do
    Api.call(fn channel ->
      req = %Proto.NewJobDescriptor{
        name: newJob.name,
        frequency: newJob.frequency,
        tolerance: newJob.tolerance,
        source_id: newJob.source_id
      }

      case Proto.SourceJob.Stub.create_job_descriptor(channel, req) do
        {:ok, newJob} -> {:ok, proto_to_descriptor(newJob)}
        {:error, msg} -> {:error, msg}
      end
    end)
  end
end
