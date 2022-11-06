#ifndef OBJECT3DMODEL_H
#define OBJECT3DMODEL_H
#include <QString>
#include <QAbstractListModel>

class Object3d
{

public:
    Object3d(const QString &name,
           const int &size,
           const int &x,
           const int &y,
           const int &z);

    QString name() const;
    int size() const;
    int mX() const;
    int mY() const;
    int mZ() const;

   private:
    QString m_name;
    int m_size;
    int m_x;
    int m_y;
    int m_z;
};

class Object3dModel : public QAbstractListModel
{
        Q_OBJECT
public:
    enum Object3dRoles {
        nameRole = Qt::DisplayRole,
        sizeRole = Qt::UserRole + 1,
        xRole    = Qt::UserRole + 2,
        yRole    = Qt::UserRole + 3,
        zRole    = Qt::UserRole + 4,
        idRole   = Qt::UserRole + 5
    };

    Object3dModel(QObject *parent = 0);

    Q_INVOKABLE void append(const QString &name,
                                 const int size,
                                 const int x,
                                 const int y,
                                 const int z);

    Q_INVOKABLE virtual int rowCount(const QModelIndex & parent = QModelIndex()) const;

    Q_INVOKABLE virtual QVariant data(const QModelIndex & index, int role = Qt::DisplayRole) const;
    Q_INVOKABLE bool removeRow(int row, const QModelIndex &parent = QModelIndex());

protected:
    virtual QHash<int, QByteArray> roleNames() const;
private:
    QList<Object3d> m_Objects3d;

};

class Object3dModelHeir : public Object3dModel
{
    Q_OBJECT
public:
    Q_INVOKABLE QVariant data(const QModelIndex & index, int role = Qt::DisplayRole) const;
};

#endif // OBJECT3DMODEL_H

