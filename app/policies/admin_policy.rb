class AdminPolicy < ApplicationPolicy
  def index?
    administrators
  end

  def show?
    administrators
  end

  def edit?
    administrators
  end

  def update
    administrators
  end

  def create?
    administrators
  end

  def destroy?
    administrators
  end
end
