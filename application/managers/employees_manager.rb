class EmployeesManager < Collector::Manager
  def initialize(employees)
    @employees = employees

    async.run
  end

  def run
    @employees.each do |employee|
      EmployeeManager.run(employee[:id], employee[:connections])
    end
  end
end
