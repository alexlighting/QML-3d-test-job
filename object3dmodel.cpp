#include "object3dmodel.h"

Object3d::Object3d(const QString &name, const int &size, const int &x, const int &y, const int &z)
    : m_name(name), m_size(size), m_x(x), m_y(y), m_z(z)
{
}

QString Object3d::name() const
{
    return m_name;
}

int Object3d::size() const
{
    return m_size;
}

int Object3d::mX() const
{
    return m_x;
}

int Object3d::mY() const
{
    return m_y;
}

int Object3d::mZ() const
{
    return m_z;
}

Object3dModel::Object3dModel(QObject *parent)
: QAbstractListModel(parent)
{

}

void Object3dModel::append(const QString &name, const int size, const int x, const int y, const int z)
{
    Object3d object3d(name, size, x, y, z);
    beginInsertRows(QModelIndex(), rowCount(), rowCount());
    m_Objects3d << object3d;
    endInsertRows();
}

int Object3dModel::rowCount(const QModelIndex & parent) const {
    Q_UNUSED(parent);
    if (parent.isValid()) {
        return 0;
    }
    return m_Objects3d.count();
}

QVariant Object3dModel::data(const QModelIndex & index, int role) const
{
    if (!index.isValid()) {
        return QVariant();
    }
    const Object3d &object3d = m_Objects3d[index.row()];
    if (role == nameRole)
        return object3d.name();
    else if (role == sizeRole)
        return object3d.size();
    else if (role == xRole)
        return object3d.mX();
    else if (role == yRole)
        return object3d.mY();
    else if (role == zRole)
        return object3d.mZ();
    return QVariant();
}

bool Object3dModel::removeRow(int row, const QModelIndex &parent)
{
    Q_UNUSED(parent);
    beginRemoveRows(QModelIndex(), row, row);
    m_Objects3d.removeAt(row);
    endRemoveRows();
    return true;
}

QHash<int, QByteArray> Object3dModel::roleNames() const {
    QHash<int, QByteArray> roles;
    roles[nameRole] = "name";
    roles[sizeRole] = "size";
    roles[xRole] = "x";
    roles[yRole] = "y";
    roles[zRole] = "z";
    return roles;
}

QVariant Object3dModelHeir::data(const QModelIndex & index, int role ) const
{
    //здесь мы можем переопределить функцию data для наследника класса Object3dModel, если нам это
    //для чего-то потребовалось.
    return QVariant();
}
